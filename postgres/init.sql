CREATE TABLE professores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    habilitacoes VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE cursos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sigla VARCHAR(10) NOT NULL UNIQUE,
    professor_coordenador_id INT NOT NULL REFERENCES professores(id),
    tipo VARCHAR(20) NOT NULL
);

CREATE TABLE disciplinas (
    sigla VARCHAR(10) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    professor_responsavel_id INT NOT NULL REFERENCES professores(id)
);

CREATE TABLE alunos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    curso_id INT NOT NULL REFERENCES cursos(id),
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE aluno_disciplinas (
    aluno_id INT NOT NULL REFERENCES alunos(id),
    disciplina_sigla VARCHAR(10) NOT NULL REFERENCES disciplinas(sigla),
    PRIMARY KEY (aluno_id, disciplina_sigla)
);

INSERT INTO professores (nome, habilitacoes, email) VALUES
('Ana Silva', 'Doutoramento', 'asilva@unipvc.pt'),
('Bruno Costa', 'Mestrado', 'bcosta@unipvc.pt'),
('Carla Mendes', 'Doutoramento', 'cmendes@unipvc.pt'),
('Diogo Santos', 'Doutoramento', 'dsantos@unipvc.pt'),
('Elsa Pinto', 'Mestrado', 'epinto@unipvc.pt'),
('Fabio Lima', 'Mestrado', 'flima@unipvc.pt');

INSERT INTO cursos (nome, sigla, professor_coordenador_id, tipo) VALUES
('Engenharia Informática', 'EI', 1, 'Licenciatura'),
('Design Gráfico', 'DG', 2, 'Mestrado'),
('Gestão de Empresas', 'GE', 3, 'Licenciatura'),
('Enfermagem', 'ENF', 4, 'Licenciatura');

INSERT INTO disciplinas (sigla, nome, professor_responsavel_id) VALUES
('BD', 'Bases de Dados', 1),
('POO', 'Programação Orientada a Objetos', 2),
('RC', 'Redes de Computadores', 5),
('SO', 'Sistemas Operativos', 6),
('TW', 'Tecnologias Web', 1),
('D2D', 'Design 2D', 2),
('D3D', 'Design 3D', 3),
('UX', 'User Experience', 4),
('UI', 'User Interface', 5),
('HDA', 'História da Arte', 6),
('GOR', 'Gestão Operacional', 3),
('MAC', 'Macroeconomia', 4),
('AN', 'Anatomia', 5),
('FIS', 'Fisiologia', 6),
('FAR', 'Farmacologia', 1);

INSERT INTO alunos (nome, curso_id, email) VALUES
('Tiago Costa', 1, 'tcosta@unipvc.pt'),
('Ines Martins', 2, 'imartins@unipvc.pt'),
('Rui Rodrigues', 3, 'rrodrigues@unipvc.pt'),
('Sofia Sousa', 4, 'ssousa@unipvc.pt'),
('Nuno Fernandes', 1, 'nfernandes@unipvc.pt'),
('Catarina Lopes', 2, 'clopes@unipvc.pt'),
('Miguel Marques', 3, 'mmarques@unipvc.pt'),
('Beatriz Gomes', 4, 'bgomes@unipvc.pt'),
('Bruno Monteiro', 1, 'bmonteiro@unipvc.pt'),
('Joana Mendes', 2, 'jmendes@unipvc.pt'),
('Hugo Carvalho', 3, 'hcarvalho@unipvc.pt'),
('Diana Pinto', 4, 'dpinto@unipvc.pt'),
('Andre Ribeiro', 1, 'aribeiro@unipvc.pt'),
('Rita Almeida', 2, 'ralmeida@unipvc.pt'),
('Diogo Machado', 3, 'dmachado@unipvc.pt'),
('Sara Castro', 4, 'scastro@unipvc.pt'),
('Rafael Fonseca', 1, 'rfonseca@unipvc.pt'),
('Laura Rocha', 2, 'lrocha@unipvc.pt'),
('Luis Alves', 3, 'lalves@unipvc.pt'),
('Marta Soares', 4, 'msoares@unipvc.pt'),
('Carlos Neves', 1, 'cneves@unipvc.pt'),
('Patricia Pires', 2, 'ppires@unipvc.pt'),
('Ricardo Morais', 3, 'rmorais@unipvc.pt'),
('Mariana Cunha', 4, 'mcunha@unipvc.pt'),
('Filipe Baptista', 1, 'fbaptista@unipvc.pt'),
('Teresa Borges', 2, 'tborges@unipvc.pt'),
('Paulo Lourenco', 3, 'plourenco@unipvc.pt'),
('Daniela Miranda', 4, 'dmiranda@unipvc.pt'),
('Jorge Araujo', 1, 'jaraujo@unipvc.pt'),
('Vanessa Freitas', 2, 'vfreitas@unipvc.pt'),
('Goncalo Teixeira', 3, 'gteixeira@unipvc.pt'),
('Claudia Leite', 4, 'cleite@unipvc.pt'),
('David Barbosa', 1, 'dbarbosa@unipvc.pt'),
('Tatiana Mota', 2, 'tmota@unipvc.pt'),
('Ines Cardoso', 3, 'icardoso@unipvc.pt'),
('Rui Coelho', 4, 'rcoelho@unipvc.pt'),
('Sofia Correia', 1, 'scorreia@unipvc.pt'),
('Nuno Vieira', 2, 'nvieira@unipvc.pt'),
('Catarina Rebelo', 3, 'crebelo@unipvc.pt'),
('Miguel Faria', 4, 'mfaria@unipvc.pt'),
('Beatriz Tavares', 1, 'btavares@unipvc.pt'),
('Bruno Antunes', 2, 'bantunes@unipvc.pt'),
('Joana Lima', 3, 'jlima@unipvc.pt'),
('Hugo Barros', 4, 'hbarros@unipvc.pt'),
('Diana Guedes', 1, 'dguedes@unipvc.pt'),
('Andre Duarte', 2, 'aduarte@unipvc.pt'),
('Rita Fidalgo', 3, 'rfidalgo@unipvc.pt'),
('Diogo Valente', 4, 'dvalente@unipvc.pt'),
('Sara Pimenta', 1, 'spimenta@unipvc.pt'),
('Rafael Salgado', 2, 'rsalgado@unipvc.pt'),
('Laura Cruz', 3, 'lcruz@unipvc.pt'),
('Luis Reis', 4, 'lreis@unipvc.pt'),
('Marta Valente', 1, 'mvalente@unipvc.pt'),
('Carlos Viana', 2, 'cviana@unipvc.pt'),
('Patricia Machado', 3, 'pmachado@unipvc.pt'),
('Ricardo Vicente', 4, 'rvicente@unipvc.pt'),
('Mariana Nogueira', 1, 'mnogueira@unipvc.pt'),
('Filipe Lemos', 2, 'flemos@unipvc.pt'),
('Teresa Pacheco', 3, 'tpacheco@unipvc.pt'),
('Paulo Figueiredo', 4, 'pfigueiredo@unipvc.pt'),
('Daniela Melo', 1, 'dmelo@unipvc.pt'),
('Jorge Guimaraes', 2, 'jguimaraes@unipvc.pt'),
('Vanessa Matias', 3, 'vmatias@unipvc.pt'),
('Goncalo Peixoto', 4, 'gpeixoto@unipvc.pt'),
('Claudia Azevedo', 1, 'cazevedo@unipvc.pt'),
('David Moura', 2, 'dmoura@unipvc.pt'),
('Tatiana Ramos', 3, 'tramos@unipvc.pt'),
('Ines Pinho', 4, 'ipinho@unipvc.pt'),
('Rui Magalhaes', 1, 'rmagalhaes@unipvc.pt'),
('Sofia Branco', 2, 'sbranco@unipvc.pt'),
('Nuno Sequeira', 3, 'nsequeira@unipvc.pt'),
('Catarina Teles', 4, 'cteles@unipvc.pt'),
('Miguel Velez', 1, 'mvelez@unipvc.pt'),
('Beatriz Dinis', 2, 'bdinis@unipvc.pt'),
('Bruno Simoes', 3, 'bsimoes@unipvc.pt'),
('Joana Caires', 4, 'jcaires@unipvc.pt'),
('Hugo Paiva', 1, 'hpaiva@unipvc.pt'),
('Diana Lira', 2, 'dlira@unipvc.pt'),
('Andre Maciel', 3, 'amaciel@unipvc.pt'),
('Rita Bessa', 4, 'rbessa@unipvc.pt'),
('Diogo Piedade', 1, 'dpiedade@unipvc.pt'),
('Sara Godinho', 2, 'sgodinho@unipvc.pt'),
('Rafael Brito', 3, 'rbrito@unipvc.pt'),
('Laura Vidal', 4, 'lvidal@unipvc.pt'),
('Luis Paca', 1, 'lpaca@unipvc.pt'),
('Marta Candeias', 2, 'mcandeias@unipvc.pt'),
('Carlos Beja', 3, 'cbeja@unipvc.pt'),
('Patricia Frias', 4, 'pfrias@unipvc.pt'),
('Ricardo Telles', 1, 'rtelles@unipvc.pt'),
('Mariana Silveira', 2, 'msilveira@unipvc.pt'),
('Filipe Cordeiro', 3, 'fcordeiro@unipvc.pt'),
('Teresa Meireles', 4, 'tmeireles@unipvc.pt'),
('Paulo Varela', 1, 'pvarela@unipvc.pt'),
('Daniela Viana', 2, 'dviana@unipvc.pt'),
('Jorge Castelo', 3, 'jcastelo@unipvc.pt'),
('Vanessa Amorim', 4, 'vamorim@unipvc.pt'),
('Goncalo Sampaio', 1, 'gsampaio@unipvc.pt'),
('Claudia Valadares', 2, 'cvaladares@unipvc.pt'),
('David Bettencourt', 3, 'dbettencourt@unipvc.pt'),
('Tatiana Furtado', 4, 'tfurtado@unipvc.pt');

INSERT INTO aluno_disciplinas (aluno_id, disciplina_sigla)
SELECT id, 'BD' FROM alunos WHERE curso_id = 1 UNION ALL
SELECT id, 'POO' FROM alunos WHERE curso_id = 1 UNION ALL
SELECT id, 'RC' FROM alunos WHERE curso_id = 1 UNION ALL
SELECT id, 'SO' FROM alunos WHERE curso_id = 1 UNION ALL
SELECT id, 'TW' FROM alunos WHERE curso_id = 1 UNION ALL
SELECT id, 'D2D' FROM alunos WHERE curso_id = 2 UNION ALL
SELECT id, 'D3D' FROM alunos WHERE curso_id = 2 UNION ALL
SELECT id, 'UX' FROM alunos WHERE curso_id = 2 UNION ALL
SELECT id, 'UI' FROM alunos WHERE curso_id = 2 UNION ALL
SELECT id, 'HDA' FROM alunos WHERE curso_id = 2 UNION ALL
SELECT id, 'GOR' FROM alunos WHERE curso_id = 3 UNION ALL
SELECT id, 'MAC' FROM alunos WHERE curso_id = 3 UNION ALL
SELECT id, 'BD' FROM alunos WHERE curso_id = 3 UNION ALL
SELECT id, 'TW' FROM alunos WHERE curso_id = 3 UNION ALL
SELECT id, 'POO' FROM alunos WHERE curso_id = 3 UNION ALL
SELECT id, 'AN' FROM alunos WHERE curso_id = 4 UNION ALL
SELECT id, 'FIS' FROM alunos WHERE curso_id = 4 UNION ALL
SELECT id, 'FAR' FROM alunos WHERE curso_id = 4 UNION ALL
SELECT id, 'RC' FROM alunos WHERE curso_id = 4 UNION ALL
SELECT id, 'SO' FROM alunos WHERE curso_id = 4;