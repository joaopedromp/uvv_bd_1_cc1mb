/* Questão 01: */
SELECT nome_departamento AS Departamento, AVG(salario) AS Média_salarial
FROM funcionario f INNER JOIN departamento d
WHERE f.numero_departamento = d.numero_departamento
GROUP BY nome_departamento;


/* Questão 02: */
SELECT sexo AS Sexo, AVG(salario) AS Média_salarial 
FROM funcionario
GROUP BY sexo;


/* Questão 03: */
SELECT nome_departamento AS Departamento, CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS Nome, 
data_nascimento AS Data_nascimento, 
FLOOR(DATEDIFF(CURDATE(), data_nascimento)/365.25) AS Idade, 
salario AS Salário 
FROM departamento d INNER JOIN funcionario f
WHERE d.numero_departamento = f.numero_departamento
ORDER BY nome_departamento;


/* Questão 04: */
SELECT CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS Nome, FLOOR(DATEDIFF(CURDATE(), data_nascimento)/365.25) AS Idade, 
salario AS Salário_atual, salario*1.15 AS Novo_salário 
FROM funcionario f
WHERE salario >= '35000'
UNION
SELECT CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS Nome, FLOOR(DATEDIFF(CURDATE(), data_nascimento)/365.25) AS Idade, 
salario AS Salário_atual, salario*1.2 AS Novo_salário 
FROM funcionario f
WHERE salario < '35000'
ORDER BY Nome ASC;


/* Questão 05: */
SELECT nome_departamento AS Departamento, ger.primeiro_nome AS Gerente, f.primeiro_nome AS Funcionário, salario AS Salário
FROM funcionario f INNER JOIN departamento d, 
(SELECT cpf, primeiro_nome FROM funcionario f INNER JOIN departamento d WHERE f.cpf = d.cpf_gerente) AS ger
WHERE d.numero_departamento = f.numero_departamento AND d.cpf_gerente = ger.cpf
ORDER BY d.nome_departamento ASC, f.salario DESC;


/* Questão 06: */
SELECT CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS Funcionário, dpt.nome_departamento AS Departamento,
dpd.nome_dependente AS Dependente, FLOOR(DATEDIFF(CURDATE(), dpd.data_nascimento)/365.25) AS Idade_dependente,
CASE WHEN dpd.sexo = 'M' THEN 'Masculino' WHEN dpd.sexo = 'F' THEN 'Feminino' END AS Sexo_dependente
FROM funcionario f INNER JOIN departamento dpt ON f.numero_departamento = dpt.numero_departamento INNER JOIN dependente dpd ON dpd.cpf_funcionario = f.cpf
ORDER BY Funcionário ASC;


/* Questão 07: */
SELECT DISTINCT CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS Funcionário, dpt.nome_departamento AS Departamento, salario AS Salário 
FROM funcionario f INNER JOIN departamento dpt INNER JOIN dependente dpd
WHERE dpt.numero_departamento = f.numero_departamento AND
f.cpf NOT IN (SELECT dpd.cpf_funcionario FROM dependente dpd)
ORDER BY Funcionário ASC;


/* Questão 08: */
SELECT d.nome_departamento AS Departamento, p.nome_projeto AS Projeto,
CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS Nome, te.horas AS Horas
FROM funcionario f INNER JOIN projeto p INNER JOIN departamento d INNER JOIN trabalha_em te
WHERE p.numero_departamento = d.numero_departamento AND f.cpf = te.cpf_funcionario AND p.numero_projeto = te.numero_projeto 
ORDER BY p.nome_projeto;


/* Questão 09: */
SELECT d.nome_departamento AS Departamento, p.nome_projeto AS Projeto, SUM(te.horas) AS Horas
FROM departamento d INNER JOIN trabalha_em te INNER JOIN projeto p
WHERE te.numero_projeto = p.numero_projeto AND p.numero_departamento = d.numero_departamento
GROUP BY p.nome_projeto;


/* Questão 10: */
SELECT nome_departamento AS Departamento, AVG(salario) AS Média_salarial
FROM departamento d INNER JOIN funcionario f
WHERE d.numero_departamento = f.numero_departamento
GROUP BY d.nome_departamento;


/* Questão 11: */
SELECT CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS Nome, p.nome_projeto AS Projeto, te.horas*50 AS Valor_total
FROM funcionario f INNER JOIN trabalha_em te INNER JOIN projeto p
WHERE f.cpf = te.cpf_funcionario AND p.numero_projeto = te.numero_projeto
GROUP BY primeiro_nome;


/* Questão 12: */
SELECT d.nome_departamento AS Departamento, p.nome_projeto AS Projeto,
CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS Funcionário, te.horas AS Horas_trabalhadas
FROM funcionario f  INNER JOIN projeto p INNER JOIN departamento d INNER JOIN trabalha_em te
WHERE f.cpf = te.cpf_funcionario AND p.numero_projeto = te.numero_projeto AND (te.horas = NULL OR te.horas = 0)
GROUP BY primeiro_nome;


/* Questão 13: */
SELECT d.nome_dependente AS Nome,
CASE WHEN sexo = 'M' THEN 'Masculino' WHEN sexo = 'F' THEN 'Feminino' END AS Sexo, FLOOR(DATEDIFF(CURDATE(), d.data_nascimento)/365.25) AS Idade
FROM dependente d 
UNION
SELECT CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS Nome,
CASE WHEN sexo = 'M' THEN 'Masculino' WHEN sexo = 'F' THEN 'Feminino' END AS Sexo, FLOOR(DATEDIFF(CURDATE(), f.data_nascimento)/365.25) AS Idade
FROM funcionario f ORDER BY Idade;


/* Questão 14: */
SELECT d.nome_departamento AS Departamento, COUNT(f.numero_departamento) AS Nº_funcionarios FROM departamento d INNER JOIN funcionario f
WHERE d.numero_departamento = f.numero_departamento
GROUP BY d.nome_departamento;


/* Questão 15: */
/*  Primeiro pesquiso quem não trabalha em nenhum projeto e depois pesquiso quem trabalha */
SELECT DISTINCT CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS Funcionário, d.nome_departamento AS Departamento, 'Nenhum' AS Projeto
FROM funcionario f INNER JOIN trabalha_em te INNER JOIN projeto p INNER JOIN departamento d
WHERE d.numero_departamento = f.numero_departamento AND p.numero_projeto = te.numero_projeto AND (f.cpf NOT IN (SELECT te.cpf_funcionario FROM trabalha_em te))
UNION
SELECT DISTINCT CONCAT(primeiro_nome, ' ', nome_meio, ' ', ultimo_nome) AS Funcionário, d.nome_departamento AS Departamento, p.nome_projeto AS Projeto
FROM funcionario f INNER JOIN trabalha_em te INNER JOIN projeto p INNER JOIN departamento d
WHERE d.numero_departamento = f.numero_departamento AND p.numero_projeto = te.numero_projeto AND te.cpf_funcionario = f.cpf;
