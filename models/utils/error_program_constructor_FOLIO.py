'''
step 2. construct error programs.
'''
import re
import random
from utils.utils import OpenAIModel, execute_logic_program, LLMConfig

program_cache_dir = './models/.cache_program'


class ErrorConstruction:
    def __init__(self, original_program:str, dataset_name:str, id:str, answer:str, NL_context:str, FOl_formulas:str, LLMargs: LLMConfig):
        self.dataset_name = dataset_name
        self.NL_context = NL_context
        self.Fol_formulas = FOl_formulas
        self.ori_program = original_program
        self.id = id
        self.answer = answer
        self.parse_flag = True
        self.parse_program()
        self.LLModel = OpenAIModel(llmconfig=LLMargs, max_new_tokens=2048)
        
    def parse_program(self):
        # extract sections, sorts and entities etc
        self.parse_flag = True
        lines = [x for x in self.ori_program.splitlines() if not x.strip() == ""]
        
        decleration_start_index = lines.index("# Declaration")
        constraint_start_index = lines.index("# Premises")
        conclusion_start_index = constraint_start_index
        for i, s in enumerate(lines):
            if s.startswith("# Question"):
                conclusion_start_index = i
        conclusion_end_index = conclusion_start_index
        for i, s in enumerate(lines):
            if s.startswith("def check_statement():"):
                conclusion_end_index = i
 
        self.declaration_statements = lines[decleration_start_index + 1:constraint_start_index]
        self.constraint_statements = lines[constraint_start_index + 1:conclusion_start_index]
        self.conclusion_statements = lines[conclusion_start_index + 1:conclusion_end_index]
        
        
        self.function_names = self.extract_function_names(self.declaration_statements) # ['func_names']
        
        self.preconds = self.parse_preconds_statement(self.constraint_statements) # [{'comment': NL, 'lines': program lines}]
        self.conclusion = self.extract_conclusion(self.conclusion_statements) # {'comment': NL, 'lines': program lines}
        
        
    def extract_function_names(self, declaration_statements):
        '''
            extract predicates names from declaration.
            input: declaration_statements: declaration part of program lines.
            output: 
            function_names = ['func_names']
        '''
        function_names = []
        try:
            for line in declaration_statements:
                if 'Function(' in line: # fun_name = Function('..', sort1, ..., sortn)
                    func_name = line.split('=')[0].strip()
                    function_names.append(func_name)
        except:
            print(f'{self.id} - declaration parsing failed:\n{line}')
            self.parse_flag = False
                
        return function_names
        
    def parse_preconds_statement(self, constraint_statements):
        '''
            extract preconditions.
            input: constraint_statements, preconds part of the program lines.
            output: preconds = [{'comment': NL, 'lines': program lines}]
        '''
        preconds = []
        comment = ''
        precond_lines = []
        try:
            ind = 0
            while ind < len(constraint_statements):
                line = constraint_statements[ind]
                if 'pre_conditions = []' in line:
                    ind += 1
                    continue
                if line.strip().startswith("# "):
                    if comment:
                        precond = {
                            'comment': comment,
                            'lines': precond_lines
                        }
                        preconds.append(precond)
                    comment = line.replace("# ", "")
                    precond_lines = []
                else:
                    precond_lines.append(line)
                
                ind += 1
            if comment:
                precond = {
                    'comment': comment,
                    'lines': precond_lines
                }
                preconds.append(precond)
                
        except:
            print(f'{self.id} - preconditions parsing failed:\n{line}')
            self.parse_flag = False

        return preconds
                
                
    def extract_conclusion(self, option_statements):
        '''
            extract the conclusion's formalization.
            input: option_statements, the rest of the program lines.
            output: conclusion = {'comment': NL of the conclusion, 'lines': program lines of the conclusion}
        '''
        ind = 0
        try:
            comment = option_statements[0].replace('# ', '')
            lines = option_statements[1:]
            conclusion = {
                'comment': comment, 
                'lines': lines
            }
            return conclusion
        except:
            print(f'{self.id} - conclusion parsing failed')
            self.parse_flag = False
            
        return None
            
        
    def missing_info_error(self, num_programs = 3):
        '''
        randomly deleting some of the preconds to get different error programs.
        num_programs: number of error programs
        outcomes are stored in self.missing_info_error_programs
        '''        
        random_delete_lists = []
        self.missing_info_error_programs = []
        if not self.parse_flag:
            print('Parsing Failure!')
            return

        if len(self.preconds) <= 1:
                return
        
        while len(random_delete_lists) < num_programs:
            # randomly decide how many preconds to delete
            num_to_remove = random.randint(1,min(3, len(self.preconds)))
            # randomly decide which preconds to delete
            delete_list = random.sample(self.preconds, num_to_remove)
            if delete_list not in random_delete_lists:
                random_delete_lists.append(delete_list)
        
        for delete_preconds in random_delete_lists:
            program_lines = self.ori_program.splitlines()
            for precond in delete_preconds: # precond is a dict {'var', 'cond'}
                start = program_lines.index('# ' + precond['comment'])
                ind = start + len(precond['lines'])
                program_lines = [x for i, x in enumerate(program_lines) if i not in range(start, ind+1)] # deleting precond and corresponding variables
            error_program = '\n'.join(program_lines)
            self.missing_info_error_programs.append(error_program)
    
                
    @staticmethod
    def substitue_sublist(main_list, old_sublist, new_sublist):
        '''
        substitute old_sublist with new_sublist in the main list.
        '''
        result = []
        ind = 0
        while ind < len(main_list):
            if main_list[ind : ind + len(old_sublist)] == old_sublist:
                # print(f"old precond occurs in line {ind}")
                result.extend(new_sublist)
                ind += len(old_sublist)
            else:
                result.append(main_list[ind])
                ind += 1
        return result
                

    def inconsistent_pairs(self, num_programs = 3):
        '''
        Construct inconsistent NL-SL pairs with LLM. First generate inequivalent formulas, then try to substitute into the program to generate error programs.
        outcomes in self.inconsistent_error_programs
        num_programs: the maximum number of the final outcome
        '''
        self.inconsistent_error_programs = []
        
        if len(self.preconds) == 0:
            return

        if not self.parse_flag:
            print('Parsing Failure!')
            return
        
        with open('./prompts/restructure_fol.txt', 'r+', encoding='utf-8') as f:
            restructure_fol_prompt_template = f.read()
            
        original_fol = self.Fol_formulas.split('Premises:\n')[1].strip()
        original_fol = original_fol.split('Conclusion:\n')[0].strip()
        
        fol_lines = original_fol.splitlines()
        
        # generate materials for llm prompting: fol+z3 expression. if the text is not in z3 program, skip this one.
        
        materials_lines = []
        ind = 0
        precond_ind = 0
        while ind < len(fol_lines):
            line = fol_lines[ind]
            if precond_ind >= len(self.preconds):
                break
            if 'Text:' in line:
                NL_comment = line.split('Text:')[1].rstrip('.')
                if NL_comment not in self.preconds[precond_ind]['comment']:
                    # this premise got deleted in missing info, thus skip to the next one
                    ind += 1
                    while ind < len(fol_lines) and 'Text:' not in fol_lines[ind]:
                        ind += 1
                else:
                    # this premise should match with preconds[precond_ind]
                    materials_lines.append(f'{precond_ind+1}. Text:{NL_comment}.')
                    ind += 1
                    # add lines in fol into material
                    while ind < len(fol_lines) and 'Text:' not in fol_lines[ind]:
                        materials_lines.append(fol_lines[ind])
                        ind += 1
                    # add linds in z3 into material
                    materials_lines.append('Z3 expression:\n```')
                    materials_lines.extend(self.preconds[precond_ind]['lines'])
                    materials_lines.append('```')
                    precond_ind += 1
        
        # print(f"===========materials for inconsistent pairs===================\n")
        # materials = '\n'.join(materials_lines)
        # print(materials)
        
        materials = '\n'.join(materials_lines)
        
        prompt = restructure_fol_prompt_template.replace('[[FOLFORMULAS]]', materials)
        
        fail_time = 0
        while fail_time < 3:
            output = self.LLModel.generate(prompt)
            if output:
                fail_time += 1
            else:
                break
        
        # print(f"========output of restruct fol==========\n{output}")
        output_lines = output.splitlines()
        new_preconds = []  # element: a list of lines of new preconds
        precond = []
        ind = 0
        while ind < len(output_lines):
            line = output_lines[ind]
            if 'Text:' in line:
                comment = line.split('Text:')[1].rstrip('.').strip()
                while not line.startswith('Z3 expression:'):
                    ind += 1
                    line = output_lines[ind]
                ind += 1
                if '```' in output_lines[ind]:
                    ind += 1
                line = output_lines[ind]
                while '```' not in line:
                    precond.append(line)
                    ind += 1
                    line = output_lines[ind]
                new_precond = {
                    'comment': comment,
                    'lines': precond
                }
                new_preconds.append(new_precond)
                precond = []
                ind += 1
            else:
                ind += 1
        new_comments = [pc['comment'] for pc in new_preconds]
        
        print("=========new preconds===========")
        for precond in new_preconds:
            print(precond)
        print(f"new comments: {new_comments}")
        print("================================")
        
        # for line in output_lines:
        #     if 'Text:' in line:
        #         comment = line.split('Text:')[1].rstrip('.')
        #     if '```' in line or '```python' in line:
        #         if z3_flag:  # the end of the z3 expression
        #             z3_flag = False
        #             new_preconds.append(precond)
        #             precond = []
        #         else:        # the start of the z3 expression
        #             z3_flag = True
        #             continue
        #     if z3_flag:
        #         precond.append(line)
        
        # print("========new preconds==========")
        # for precond in new_preconds:
        #     print(precond)
        
        fail_time = 0
        already_used_preconds = []
        while len(self.inconsistent_error_programs) < num_programs and fail_time < 7:
            if len(self.preconds) <= 1:
                substitute_preconds = list(enumerate(self.preconds))
            else:
                num_2_substitute = random.randint(1, min(len(self.preconds), 2))
                substitute_preconds = random.sample(list(enumerate(self.preconds)), num_2_substitute)
            if substitute_preconds in already_used_preconds:
                fail_time += 1
                continue
            else:
                already_used_preconds.append(substitute_preconds)
            error_program_lines = [x for x in self.ori_program.splitlines() if not x.strip() == ""]
            for (ind, old_precond) in substitute_preconds:
                old_comment = old_precond['comment'].rstrip('.').strip()
                print(f"old comment: {old_comment}")
                new_precond = new_preconds[new_comments.index(old_comment)]['lines']
                error_program_lines = self.substitue_sublist(error_program_lines, old_precond['lines'], new_precond)
                
            error_program = '\n'.join(error_program_lines)
            execution_result = execute_logic_program(error_program)
            if execution_result['flag'] == 'success' and execution_result['result'] == self.answer:
                fail_time += 1
            else:
                self.inconsistent_error_programs.append(error_program)
            
            
    
    @staticmethod
    def substitute_predicates(preds:dict, text:str):
        for old_p, new_p in preds.items():
            text = text.replace(old_p, new_p)
        return text
                
                
    def mismatch_predicates(self, num_programs = 3):
        '''
        Produce mismatch predicates with LLM, then replace them in the premises.
        outcomes in self.mismatch_predicates_err_programs
        '''
        self.mismatch_predicates_err_programs = []
        if len(self.preconds) == 0:
            return
        declaration_str = '\n'.join(self.declaration_statements)
        
        original_predicates = ', '.join(self.function_names)
        
        with open('./prompts/rephrase_predicates.txt', 'r+', encoding='utf-8') as f:
            rephrase_predicates_template = f.read()
        
        # generate rephrased predicates
        prompt = rephrase_predicates_template.replace('[[NLCONTEXT]]', self.NL_context).replace('[[DECLARATION]]', declaration_str).replace('[[PREDICATES]]', original_predicates)
        output = self.LLModel.generate(prompt)
        output_lines = output.strip().splitlines()
        # print(output)
        
        # extract new predicates: {'old': 'new'}
        rephrased_predicates = {}
        old_p = ''
        new_p = ''
        for line in output_lines:
            if line.startswith('# '):
                old_p = line.strip().replace('# ', '')
            elif 'Function(' in line:
                new_p = line.split(' = ')[0].strip()
                rephrased_predicates[old_p] = new_p
            
        # generate error programs with predicate substitution
        # for each one, select 1-2 premises to do the substitution
        
        exec_time = 0
        already_used_preconds = []
        while len(self.mismatch_predicates_err_programs) < num_programs and exec_time < 7:
            if len(self.preconds) <= 1:
                subs_preconds = self.preconds
            else:
                subs_preconds = random.sample(self.preconds, random.randint(1, min(2, len(self.preconds))) )
            if subs_preconds in already_used_preconds:
                exec_time += 1
                continue
            else:
                already_used_preconds.append(subs_preconds)
            err_program = self.ori_program
            for precond in subs_preconds:
                new_lines = []
                for line in precond['lines']:
                    if line.startswith('pre_conditions.append'):
                        line = self.substitute_predicates(rephrased_predicates, line)
                    new_lines.append(line)
                    
                old_precond_str = '\n'.join(precond['lines'])
                new_precond_str = '\n'.join(new_lines)
                err_program = err_program.replace(old_precond_str, new_precond_str)
            
            if err_program not in self.mismatch_predicates_err_programs:
                self.mismatch_predicates_err_programs.append(err_program)
            exec_time += 1
        
        
                   
                
if __name__ == "__main__":
    ori_program = "from z3 import *\n\n# Declaration\npersons_sort, (James,) = EnumSort('persons', ['James'])\n\nPresent = Function('Present', persons_sort, BoolSort())\nTutorial = Function('Tutorial', persons_sort, BoolSort())\nInPerson = Function('InPerson', persons_sort, BoolSort())\nInvited = Function('Invited', persons_sort, BoolSort())\nSouvenirs = Function('Souvenirs', persons_sort, BoolSort())\nMeals = Function('Meals', persons_sort, BoolSort())\nHappyCommunicate = Function('HappyCommunicate', persons_sort, BoolSort())\nInvitedTakePhoto = Function('InvitedTakePhoto', persons_sort, BoolSort())\n\n# Premises\npre_conditions = []\n# Either present their work at the conference or provide a tutorial session at the conference.\np = Const('p', persons_sort)\npre_conditions.append(ForAll([p], Or(Present(p), Tutorial(p))))\n\n# All who present their work at the conference will attend in person.\np = Const('p', persons_sort)\npre_conditions.append(ForAll([p], Implies(Present(p), InPerson(p))))\n\n# All those providing a tutorial session at the conference are invited to join the club.\np = Const('p', persons_sort)\npre_conditions.append(ForAll([p], Implies(Tutorial(p), Invited(p))))\n\n# All who attend the conference in person are provided with souvenirs.\np = Const('p', persons_sort)\npre_conditions.append(ForAll([p], Implies(InPerson(p), Souvenirs(p))))\n\n# All invited to join the club are provided with delicious meals.\np = Const('p', persons_sort)\npre_conditions.append(ForAll([p], Implies(Invited(p), Meals(p))))\n\n# All provided with delicious meals are happy to communicate with each other during the dinner.\np = Const('p', persons_sort)\npre_conditions.append(ForAll([p], Implies(Meals(p), HappyCommunicate(p))))\n\n# All provided with delicious meals are invited to take a photo with the audience.\np = Const('p', persons_sort)\npre_conditions.append(ForAll([p], Implies(Meals(p), InvitedTakePhoto(p))))\n\n# James does not attend the conference in person and is not provided with souvenirs.\npre_conditions.append(And(Not(InPerson(James)), Not(Souvenirs(James))))\n\n# Question: Based on the above information, is the following statement true, false, or uncertain? \n# James is provided with souvenirs.\nconclusion = Souvenirs(James)\n\ndef check_statement():\n    solver = Solver()\n    solver.add(pre_conditions)\n    # Check if statement is necessarily true\n    solver.push()\n    solver.add(Not(conclusion))\n    if solver.check() == unsat:\n        return 'A) True'\n    solver.pop()\n    # Check if statement is necessarily false  \n    solver.push()\n    solver.add(conclusion)\n    if solver.check() == unsat:\n        return 'B) False'\n    return 'C) Uncertain'\n\nprint(check_statement())"
    id = "FOLIO_train_976"
    ground_truth = "B"
    NL_context = "Either present their work at the conference or provide a tutorial session at the conference. All who present their work at the conference will attend in person. All those providing a tutorial session at the conference are invited to join the club. All who attend the conference in person are provided with souvenirs. All invited to join the club are provided with delicious meals. All provided with delicious meals are happy to communicate with each other during the dinner. All provided with delicious meals are invited to take a photo with the audience. James does not attend the conference in person and is not provided with souvenirs."
    Fol = "We can get these predicates:\nPresent(x),Tutorial(x),InPerson(x),Invited(x),Souvenirs(x),Meals(x),HappyCommunicate(x),InvitedTakePhoto(x)\nWe can get these constants:\njames\nLet's translate one by one.\nPremises:\n1.Text:Either present their work at the conference or provide a tutorial session at the conference.\nPredicates:\nTutorial(x),Present(x)\nFol:∀x ( Present(x) ∨ Tutorial(x))\n2.Text:All who present their work at the conference will attend in person.\nPredicates:\nPresent(x),InPerson(x)\nFol:∀x (Present(x) → InPerson(x))\n3.Text:All those providing a tutorial session at the conference are invited to join the club.\nPredicates:\nInvited(x),Tutorial(x)\nFol:∀x (Tutorial(x) → Invited(x))\n4.Text:All who attend the conference in person are provided with souvenirs.\nPredicates:\nSouvenirs(x),InPerson(x)\nFol:∀x (InPerson(x) → Souvenirs(x))\n5.Text:All invited to join the club are provided with delicious meals.\nPredicates:\nInvited(x),Meals(x)\nFol:∀x (Invited(x) → Meals(x))\n6.Text:All provided with delicious meals are happy to communicate with each other during the dinner.\nPredicates:\nMeals(x),HappyCommunicate(x)\nFol:∀x (Meals(x) → HappyCommunicate(x))\n7.Text:All provided with delicious meals are invited to take a photo with the audience.\nPredicates:\nMeals(x),InvitedTakePhoto(x)\nFol:∀x (Meals(x) → InvitedTakePhoto(x))\n8.Text:James does not attend the conference in person and is not provided with souvenirs.\nPredicates:\nSouvenirs(x),InPerson(x)\nConstants:\njames\nFol:¬(InPerson(james) ∧ Souvenirs(james))\nConclusion:\nText:James is provided with souvenirs.\nPredicates:\nSouvenirs(x)\nConstants:\njames\nFol:Souvenirs(james)"
    
    from LLM_config import LLM_CONFIG
    
    LLMargs = LLM_CONFIG["gpt-4o"]
    
    error_constructor = ErrorConstruction(ori_program, 'FOLIO', id, ground_truth, NL_context, Fol, LLMargs)
    print("===declaration statement===")
    print(error_constructor.declaration_statements)
    print("===preconds statement===")
    print(error_constructor.constraint_statements)
    print("===conclusion statement===")
    print(error_constructor.conclusion_statements)
    print("===function names===")
    print(error_constructor.function_names)
    print("===preconds===")
    for precond in error_constructor.preconds:
        print(precond)
    print("===conclusion===")
    print(error_constructor.conclusion)
    
    print('===============================\n')
    # error_constructor.missing_info_error()
    # for i, program in enumerate(error_constructor.missing_info_error_programs):
    #     print(f"===missing info program {i}===")
    #     print(program)
        
    error_constructor.inconsistent_pairs()
    for i, program in enumerate(error_constructor.inconsistent_error_programs):
        print(f"===inconsistent pairs program {i}===")
        print(program)
        
    # error_constructor.mismatch_predicates()
    # for i, program in enumerate(error_constructor.mismatch_predicates_err_programs):
    #     print(f"===mismatch predicates program {i}===")
    #     print(program)