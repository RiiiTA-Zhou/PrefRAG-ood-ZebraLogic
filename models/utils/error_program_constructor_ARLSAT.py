'''
step 2. construct error programs.
'''
import re
from collections import OrderedDict
import ast
import random
from utils import OpenAIModel, execute_logic_program, LLMConfig

program_cache_dir = './models/.cache_program'


class ErrorConstruction:
    def __init__(self, original_program:str, dataset_name:str, id:str, answer:str, LLMargs: LLMConfig):
        self.dataset_name = dataset_name
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
        
        decleration_start_index = lines.index("# Declarations")
        constraint_start_index = lines.index("# Pre_Conditions")
        option_start_index = constraint_start_index
        for i, s in enumerate(lines):
            if s.startswith("# Question"):
                option_start_index = i
 
        declaration_statements = lines[decleration_start_index + 1:constraint_start_index]
        constraint_statements = lines[constraint_start_index + 1:option_start_index]
        option_statements = lines[option_start_index + 1:]
        
        
        (self.enum_sort_declarations, self.int_sort_declarations, self.function_declarations) = self.parse_declaration_statement(declaration_statements)
        
        self.preconds = self.parse_preconds_statement(constraint_statements)
        self.options = self.parse_query_ops_statement(option_statements)
        
        
    def parse_declaration_statement(self, declaration_statements):
        '''
            extract definition of sorts and functions.
            input: declaration_statements: declaration part of program lines.
            output: enum_sort_declarations = {sort_name: sort_members}
            int_sort_declarations = {sort_name: range}
            function_declarations = {func_name: func_args}
        '''
        enum_sort_declarations = OrderedDict()
        int_sort_declarations = OrderedDict()
        function_declarations = OrderedDict()
        try:
            # extract sorts: possible sorts include EnumSort, IntSort
            for line in declaration_statements:
                if ' = EnumSort(' in line: # sort_name, (entities) = EnumSort(...)
                    left = line.split('=')[0].strip()
                    match = re.match(r"(\w+),\s*\((.*?)\)", left)
                    sort_name = match.group(1).strip()
                    sort_members = [x.strip() for x in match.group(2).split(',')]
                    enum_sort_declarations[sort_name] = sort_members
                elif ' = IntSort()' in line: # sort_name = IntSort()
                    sort_name = line.split('=')[0].strip()
                    sort_range = []
                    ind = declaration_statements.index(line)
                    for l in declaration_statements[ind+1:]:
                        if sort_name.replace('_sort', '') in l and '[' in l:
                            sort_range = ast.literal_eval(l.split('=')[1].strip())
                            break
                    int_sort_declarations[sort_name] = sort_range
                elif 'Function(' in line: # fun_name = Function('..', sort1, ..., sortn)
                    func_name = line.split('=')[0].strip()
                    match = re.search(r'Function\((.*)\)', line)
                    args = [arg.strip() for arg in match.group(1).split(',')]
                    func_args = args[1:]
                    function_declarations[func_name] = func_args
        except:
            print(f'{self.id} - declaration parsing failed:\n{line}')
            self.parse_flag = False
                
        return enum_sort_declarations, int_sort_declarations, function_declarations
        
    def parse_preconds_statement(self, constraint_statements):
        '''
            extract preconditions.
            input: constraint_statements, preconds part of the program lines.
            output: preconds = [{'vars':{var_name:var_sort},
                                 'cond':program line,
                                 'comment':comment}]
        '''
        preconds = []
        var_dict = OrderedDict()
        comment = ''
        try:
            for line in constraint_statements:
                if line.strip().startswith("# "):
                    comment = line
                elif 'Const(' in line: # p = Const('p', people_sort)
                    match = re.match(r"(\w+)\s*=\s*Const\(\s*'(\w+)'\s*,\s*(\w+)\s*\)", line)
                    var_name = match.group(1).strip()
                    var_sort = match.group(3).strip()
                    var_dict[var_name] = var_sort
                elif 'pre_conditions.append(' in line:
                    precond_str = line
                    preconds.append({
                        'vars': var_dict,
                        'cond': precond_str,
                        'comment': comment
                    })
                    var_dict = OrderedDict()
                    comment = ''
        except:
            print(f'{self.id} - preconditions parsing failed:\n{line}')
            self.parse_flag = False
        return preconds
                
    def parse_query_ops_statement(self, option_statements):
        '''
            extract the python function declaration to query and the options.
            input: option_statements, the rest of the program lines.
            output: defined_funcs = {func_name:func_lines(a list)}
                    options = {'A': line, ...}
        '''
        defined_funcs = OrderedDict()
        options = OrderedDict()
        ind = 0
        try:
            while ind < len(option_statements):
                line = option_statements[ind]
                if 'def ' in line:  # a function
                    func_lines = [line]
                    func_name = re.match(r"def\s+(\w+)\(", line).group(1)
                    ind += 1
                    while ind < len(option_statements):
                        l = option_statements[ind]
                        if l.startswith('    '): # starts with TAB
                            func_lines.append(l)
                            ind += 1
                        else: break
                    defined_funcs[func_name] = func_lines
                elif "print(" in line:  # the first option
                    match = re.search(r"print\('\(([A-E])\)'\)", line)
                    if match:
                        option_key = match.group(1)  # A, B, C, D, E
                        options[option_key] = line
                    ind += 1
                else:
                    ind += 1
        except:
            print(f'{self.id} - options parsing failed:\n{line}')
            self.parse_flag = False
            
        return defined_funcs, options
            
        
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
        
        while len(random_delete_lists) < num_programs:
            # randomly decide how many preconds to delete
            num_to_remove = random.randint(1,3)
            while num_to_remove >= len(self.preconds):
                num_to_remove -= 1
            # randomly decide which preconds to delete
            delete_list = random.sample(self.preconds, num_to_remove)
            if delete_list not in random_delete_lists:
                random_delete_lists.append(delete_list)
        
        for delete_preconds in random_delete_lists:
            program_lines = self.ori_program.splitlines()
            for precond in delete_preconds: # precond is a dict {'var', 'cond'}
                ind = program_lines.index(precond['cond'])
                var_len = len(precond['vars'])
                start = max(0, ind - var_len)
                if start != 0 and program_lines[start-1].startswith('# '): # find the comment
                    start -= 1
                program_lines = [x for i, x in enumerate(program_lines) if i not in range(start, ind+1)] # deleting precond and corresponding variables
            error_program = '\n'.join(program_lines)
            self.missing_info_error_programs.append(error_program)
    
    
    def find_continuous_numbered_enums(self):
        """
        Identify enum types whose members have consecutive numbering in their names.      
        Returns: List of enum sort names that meet the consecutive numbering pattern
        """
        continuous_numbered_enums = []
        
        for sort_name, members in self.enum_sort_declarations.items():
            # Skip if there are less than 2 members (can't form a sequence)
            if len(members) < 2: continue
                
            # Extract prefixes and numbers from all members
            prefixes = set()
            numbers = []
            pattern_matched = True
            
            for member in members:
                # Match pattern: one or more letters followed by one or more digits
                match = re.match(r'^([a-zA-Z]+)(\d+)$', str(member))
                if not match:
                    pattern_matched = False
                    break
                    
                prefix, num_str = match.groups()
                prefixes.add(prefix)
                numbers.append(int(num_str))
                
            # Check three conditions:
            # 1. All members matched the pattern
            # 2. All members share the same prefix 
            # 3. Numbers form a consecutive sequence starting from min number
            if (pattern_matched and 
                len(prefixes) == 1 and 
                numbers == list(range(min(numbers), max(numbers)+1))):
                continuous_numbered_enums.append(sort_name)
                
        return continuous_numbered_enums
    
    @staticmethod
    def replace_members_with_numbers(text, members, numbers):
        """
        revise the enum members in line into corresponding numbers. for declaration_Enum2Int
        """
        member_to_num = dict(zip(members, numbers))
        sorted_members = sorted(members, key=len, reverse=True)
        
        for member in sorted_members:
            pattern = r'\b' + re.escape(member) + r'\b'
            text = re.sub(pattern, str(member_to_num[member]), text)
        return text
            
    def declaration_Enum2Int(self):
        '''
        Revise possible EnumSort into IntSort. Identify the candidate sort by numbers in enum members' names. Revise the declaration. Then, replace the orginal enum members in the preconds into numbers.
        outcomes are stored in self.Enum2Int_error_programs
        '''
        # find candidate enum sorts
        self.Enum2Int_error_programs = []
        if not self.parse_flag:
            print('Parsing Failure!')
            return
        candidate_sorts = self.find_continuous_numbered_enums()
        ori_lines = self.ori_program.splitlines()
        for candidate_name in candidate_sorts:
            program_lines = ori_lines[:]
            name = candidate_name.replace('_sort', '')
            preconds_flag = False
            for i, line in enumerate(program_lines):
                if line.startswith(f"{candidate_name}, "): # find declaration line and revise
                    program_lines[i] = f"{candidate_name} = IntSort()"                     
                elif line.strip().startswith(f"{name} = ["):  # find member list line and revise
                    members = self.enum_sort_declarations[candidate_name]
                    numbers = []
                    for member in members: # extract numbers
                        match = re.search(r'\d+', member)
                        if match:
                            numbers.append(int(match.group()))
                    program_lines[i] = f"{name} = {numbers}" 
                # revise the members into numbers in preconds and query
                elif line.strip().startswith("# Pre_Conditions"):
                    preconds_flag = True
                if preconds_flag and not line.strip().startswith("# "):    
                    program_lines[i] = self.replace_members_with_numbers(line, members, numbers)
                    
            error_program = '\n'.join(program_lines)
            self.Enum2Int_error_programs.append(error_program)
    
    @staticmethod
    def replace_numbers_with_members(text, numbers, members):
        """
            Revise the numbers in line into enum members, only when the number is not adjacent to other digits or letters.
        """
        num_to_member = dict(zip(numbers, members))
        sorted_numbers = sorted(numbers, key=lambda x: -len(str(x)))
        for num in sorted_numbers:
            pattern = r'(?<![a-zA-Z0-9])' + re.escape(str(num)) + r'(?![a-zA-Z0-9])'
            text = re.sub(pattern, num_to_member[num], text)
        return text
    
    def declaration_Int2Enum(self):
        '''
            Revise IntSort into EnumSort. use the first letter in sort name as members' prefix.
            outcomes in self.Int2Enum_error_programs.
        '''
        self.Int2Enum_error_programs = []
        if not self.parse_flag:
            print('Parsing Failure!')
            return
        ori_lines = self.ori_program.splitlines()
        for sort_name in self.int_sort_declarations:
            program_lines = ori_lines[:]
            int_range = self.int_sort_declarations[sort_name]
            name = sort_name.replace("_sort", "")
            name_prefix = name[0] # members' name prefix
            members = [f'{name_prefix}{str(num)}' for num in int_range]
            members_str = ', '.join(members)
            declare_line = f"{sort_name}, ({members_str}) = EnumSort('{name}', {members})"
            preconds_flag = False
            for i, line in enumerate(program_lines):
                if line.strip() == f"{sort_name} = IntSort()": # revise declaration line
                    program_lines[i] = declare_line
                elif line.strip().startswith(f"{name} = ["): # revise list line
                    program_lines[i] = f"{name} = [{members_str}]"
                elif line.strip().startswith("# Pre_Conditions"):
                    preconds_flag = True
                if preconds_flag and not line.strip().startswith("# "):# revise members in preconds and query
                    program_lines[i] = self.replace_numbers_with_members(line, int_range, members)
            error_program = '\n'.join(program_lines)
            self.Int2Enum_error_programs.append(error_program)
                

    def inconsistent_pairs(self, num_programs = 3):
        '''
        Construct inconsistent NL-SL pairs with LLM. First rephrase the NL sentences to add complexity, then translate them into SL, hoping to introduce inconsistent error.
        outcomes in self.inconsistent_error_programs
        num_programs: the maximum number of the final outcome
        '''
        self.inconsistent_error_programs = []
        error_programs = []
        if not self.parse_flag:
            print('Parsing Failure!')
            return
        rephrase_NL_prompt_fn = './prompts/Rephrase_NL.txt'
        NL2SL_pair_prompt_fn = './prompts/NL2SL_pair.txt'
        with open(rephrase_NL_prompt_fn, 'r+') as file:
            rephrase_NL_prompt_template = file.read()
        with open(NL2SL_pair_prompt_fn, 'r+') as file:
            NL2SL_pair_prompt_template = file.read()
        
        precond_comments = [item['comment'].replace("# ", "") for item in self.preconds if item['comment']]
        NL_sentences_str = '\n###\n'.join(precond_comments)
        # print(NL_sentences_str)
        rephrase_NL_prompt = rephrase_NL_prompt_template.replace("[[NLSENTENCES]]", NL_sentences_str)
        # print('rephrasing NLs...')
        rephrased_NLs_str = self.LLModel.generate(rephrase_NL_prompt)
        # print(f'**rephrased NLs**\n{rephrased_NLs_str}')
        
        lines = [x for x in self.ori_program.splitlines() if not x.strip() == ""]
        decleration_start_index = lines.index("# Declarations")
        constraint_start_index = lines.index("# Pre_Conditions")
        declare_lines = lines[decleration_start_index:constraint_start_index-1]
        declaration_str = '\n'.join(declare_lines)
        
        # print('generating SLs...')
        NL2SL_pair_prompt = NL2SL_pair_prompt_template.replace("[[DECLARATION]]", declaration_str).replace("[[NLSENTENCES]]", rephrased_NLs_str)
        
        regened_SLs = self.LLModel.generate(NL2SL_pair_prompt)
        # print(regened_SLs)
        regened_SL_lines = regened_SLs.strip().splitlines()
        regened_SL_lines = [ x for x in regened_SLs.strip().splitlines() if x]
        comment = ''
        z3_lines = []
        regened_preconds = []
        # store them into a dict. note that these preconds are only the commented ones.
        for line in regened_SL_lines:
            if line.strip().startswith("# "):
                comment = line
            elif 'Const(' in line: # p = Const('p', people_sort)
                z3_lines.append(line)
            elif 'pre_conditions.append(' in line:
                z3_lines.append(line)
                regened_preconds.append(z3_lines)
                z3_lines = []
                comment = ''
        # print(f'**regened preconds**\n{regened_preconds}')
        # revise the preconds in the original program one by one and save those error ones.
        for comment_ind, comment in enumerate(precond_comments): # origin comments
            # print(comment)
            program_lines = self.ori_program.splitlines()
            for i, line in enumerate(program_lines):
                if comment in line: 
                    precond = []
                    for l in program_lines[i+1:]:
                        if not l.startswith('# '):
                            precond.append(l)
                        else: break
                        if l.startswith('pre_conditions.append(') and precond != []:
                            break
                    break
            precond_str = '\n'.join(precond)
            # print(precond_str)
            try:
                rephrased_precond_str = '\n'.join(regened_preconds[comment_ind])
                program = self.ori_program.replace(precond_str, rephrased_precond_str)
                # print('**candidate error program**')
                # print(program)
                execution_result = execute_logic_program(program, program_cache_dir)
                if execution_result['flag'] == 'success' and execution_result['result'] == self.answer:
                    pass
                else:
                    error_programs.append(program)
                    # print(f'an inconsistent error program is produced. corresponding comment: {comment}')
            except:
                pass
            
            # randomly choose [num_programs] programs in the final result
            if len(error_programs) > num_programs:
                self.inconsistent_error_programs = random.sample(error_programs, num_programs)
            