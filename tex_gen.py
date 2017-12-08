# -*- coding: UTF-8 -*-

import codecs
import sys

kIntrod = """
\documentclass{article}
\usepackage[utf8]{inputenc}
\usepackage{color}
\usepackage[a4paper, total={7in, 9in}]{geometry}
\\begin{document}
\setlength{\parindent}{0pt}

Faremos neste momento a chamada para a premiação dos alunos, que deverão apresentar-se à frente do palco, para receberem suas medalhas e certificados a serem entregues pelos componentes da mesa.\\\\
\\textit{(Cada seção definida por um bullet point representa um conjunto de alunos que será chamado simultaneamente ao palco)}\\\\
"""

kPresSentences = {	'ini1': u'Iniciaremos a premiação com a Modalidade Iniciação Nível 1, para alunos até o sétimo ano (sexta série) do Ensino Fundamental',
				  	'ini2': u'Passamos agora à Modalidade Iniciação Nível 2, para alunos até o nono ano (oitava série) do Ensino Fundamental',
				  	'pj': u'Passamos agora à premiação da Modalidade Programação Nível Júnior, para alunos até o nono ano (oitava série) do Ensino Fundamental',
				  	'p1': u'Passamos agora à premiação da Modalidade Programação Nível 1, para alunos até o segundo ano do ensino médio',
				  	'p2': u'Passamos agora à premiação da Modalidade Programação Nível 2, para alunos até o terceiro ano do ensino médio'}

kCats = [('Iniciação Nível 1', 'ini1'), ('Iniciação Nível 2', 'ini2'), ('Programação Nível Júnior', 'pj'), ('Programação Nível 1', 'p1'), ('Programação Nível 2', 'p2')]

kMedals = [u'Medalhas de Ouro', u'Medalhas de Prata', u'Medalhas de Bronze', u'Honra ao Mérito']

kAssistProfsMessage = """
Finalmente faremos um agradecimento especial aos professores e monitores que se dedicaram aos cursos e aos cuidados dos alunos.
Nós os chamaremos agora para entrega dos certificados de monitoria e para que recebam os merecidos aplausos:\\\\

Os Professores:
"""

def parseList(fileName):
	medalsIdx = 0
	ans = []
	with codecs.open("raw/%s.txt" % fileName, encoding='utf-8', mode='r') as f:
		for line in f:
			tokens = line.split('\t')
			if 'HM' in tokens:
				tokens.remove('HM')
			if len(tokens) == 1:
				medalsIdx = (medalsIdx + 1)%4
			else:
				entry = {'medal': kMedals[medalsIdx], 'group': tokens[0], 'rank': tokens[1], 'name': tokens[3], 'school': tokens[4], 'city': tokens[5], 'state': tokens[6]}
				ans.append(entry)
	return ans[::-1]

def parseRegList(fileName):
	ans = []
	with codecs.open("raw/%s.txt" % fileName, encoding='utf-8', mode='r') as f:
		for line in f:
			ans.append(line.rstrip())
	return ans

def genCatTex(cat, catId):
	ans = u"""
\color{blue}
\\textbf{%s}\\\\\\\\""" % kPresSentences[catId]

	l = parseList(catId)
	curMedal = u""
	shouldEnd = False
	idx = 0
	while idx < len(l):
		entry = l[idx]
		medal = entry['medal']
		if medal != curMedal:
			curMedal = medal
			if shouldEnd:
				ans += '\\end{itemize}\n'
				shouldEnd = False
			ans += u"""
\\textbf{\color{blue}Ganhadores de %s, \color{black}%s}
\color{black}
""" % (medal, cat)
			ans += '\n\\begin{itemize}\n'
			shouldEnd = True

		cgroup = entry['group']
		ans += "\item\n"
		while idx < len(l) and l[idx]['group'] == cgroup:
			entry = l[idx]
			ans += "\\textbf{%sº lugar} - \\textbf{%s} – %s – %s/%s\n\n" % (entry['rank'], entry['name'], entry['school'], entry['city'], entry['state'])
			idx += 1
		ans += '\n'

	if shouldEnd:
		ans += '\\end{itemize}\n'

	return ans
	
def genListTex(fileName):
	ans = '\n\\begin{itemize}\n'
	l = parseRegList(fileName)
	for entry in l:
		ans += "\item %s\n" % entry
	ans += '\\end{itemize}\n'
	return ans

def main():
	ans = kIntrod
	for cat, catId in kCats:
		tex = genCatTex(cat, catId)
		ans += tex

	ans += kAssistProfsMessage
	ans += genListTex('professors')
	ans += "\nOs Monitores:\n"
	ans += genListTex('assistants')
	ans += '\end{document}'
	print(ans)

if __name__ == '__main__':
	reload(sys)  
	sys.setdefaultencoding('utf8')	
	main()