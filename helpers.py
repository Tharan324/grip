#!/usr/bin/env python3

import os
import shutil

"""Helper function to check if two files differ in content
   Takes in the filepath to two files
   Returns True if the files are the same, False if they are different"""
def diff(file1, file2):
        with open(file1, 'r') as f1, open(file2, 'r') as f2:
                return f1.read() == f2.read()

"""Helper function to create a commit
   Takes in the path of the parent commit, branch path, and the commit message
   creates a commit"""
def create_commit(parent_commit_path, branch_path, message):
        if parent_commit_path != '':
                commit_count = int(os.path.basename(parent_commit_path)) + 1
                new_commit_path = f'.grip/commits/{commit_count}'
        else:
                commit_count = 0
                new_commit_path = f'.grip/commits/{commit_count}'
        
        os.mkdir(new_commit_path)

        if commit_count != 0:
                with open(f'{new_commit_path}/PARENT', 'w') as parent_pointer:
                        parent_pointer.write(parent_commit_path + '\n')
        
        with open(f'{new_commit_path}/MESSAGE', 'w') as commit_message:
                commit_message.write(message + '\n')
        
        for file in os.listdir('.grip/INDEX'):
                file_path = os.path.join('.grip/INDEX', file)
                shutil.copy(file_path, new_commit_path)
        
        print(f'Committed as commit {commit_count}')

        with open(f'{branch_path}/ref', 'w') as ref:
                ref.write(new_commit_path + '\n')