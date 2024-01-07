import subprocess

cat = ['cat', 'test.txt']
grep = ['grep', '-n', 'test']
ls = ['ls', '-a']

p1 = subprocess.run(cat, capture_output = True, text = True, check=True)
print(f'p1 = {p1.stdout}\n')

p2 = subprocess.run(grep,
                    capture_output = True, text = True, input = p1.stdout, check=True)
print(f'p2 = {p2.stdout}\n')

p3 = subprocess.run(ls, shell=True, text=True, check=True)
