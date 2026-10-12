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

DO $$
DECLARE
    i INT;
    j INT;
    c_id INT;
    d_array VARCHAR(10)[] := ARRAY['BD', 'POO', 'RC', 'SO', 'TW', 'D2D', 'D3D', 'UX', 'UI', 'HDA', 'GOR', 'MAC', 'AN', 'FIS', 'FAR'];
BEGIN
    FOR i IN 1..100 LOOP
        c_id := (i % 4) + 1;

        INSERT INTO alunos (nome, curso_id, email)
        VALUES ('Aluno ' || i, c_id, 'aaluno' || i || '@unipvc.pt');

        FOR j IN 1..5 LOOP
            INSERT INTO aluno_disciplinas (aluno_id, disciplina_sigla)
            VALUES (i, d_array[((i + j) % 15) + 1]);
        END LOOP;
    END LOOP;
END $$;