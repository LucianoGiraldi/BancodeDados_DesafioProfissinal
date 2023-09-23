REM   Script: BancoDesafioProfissional
REM   Banco de dados do desafio profissional


CREATE OR REPLACE TRIGGER Atualiza_Quantidade_Medicamento 
AFTER INSERT ON Solicitacoes 
FOR EACH ROW 
BEGIN 
    IF :NEW.Status = 'Atendida' THEN 
        -- Atualiza a quantidade disponível do medicamento 
        UPDATE Medicamentos 
        SET Quantidade_Disponivel = Quantidade_Disponivel - :NEW.Quantidade 
        WHERE ID_Medicamento = :NEW.ID_Medicamento; 
    END IF; 
END;
/

CREATE TABLE Pacientes ( 
    ID_Paciente NUMBER PRIMARY KEY, 
    Nome VARCHAR2(100), 
    Data_Nascimento DATE, 
    Endereco VARCHAR2(255), 
    Telefone VARCHAR2(20) 
);

CREATE TABLE Medicos ( 
    ID_Medico NUMBER PRIMARY KEY, 
    Nome VARCHAR2(100), 
    Especialidade VARCHAR2(100), 
    CRM VARCHAR2(20) 
    -- Outros campos relevantes 
);

CREATE TABLE Consultas ( 
    ID_Consulta NUMBER PRIMARY KEY, 
    ID_Paciente NUMBER, 
    ID_Medico NUMBER, 
    Data_Consulta DATE, 
    Horario_Consulta TIMESTAMP, 
    Status VARCHAR2(50), 
    -- Outros campos relevantes 
    CONSTRAINT FK_Paciente_Consulta FOREIGN KEY (ID_Paciente) REFERENCES Pacientes(ID_Paciente), 
    CONSTRAINT FK_Medico_Consulta FOREIGN KEY (ID_Medico) REFERENCES Medicos(ID_Medico) 
);

CREATE TABLE Medicamentos ( 
    ID_Medicamento NUMBER PRIMARY KEY, 
    Nome VARCHAR2(100), 
    Quantidade_Disponivel NUMBER, 
    Descricao VARCHAR2(255) 
    -- Outros campos relevantes 
);

CREATE TABLE Solicitacoes ( 
    ID_Solicitacao NUMBER PRIMARY KEY, 
    ID_Paciente NUMBER, 
    ID_Medicamento NUMBER, 
    Data_Solicitacao DATE, 
    Quantidade NUMBER, 
    Status VARCHAR2(50), 
    -- Outros campos relevantes 
    CONSTRAINT FK_Paciente_Solicitacao FOREIGN KEY (ID_Paciente) REFERENCES Pacientes(ID_Paciente), 
    CONSTRAINT FK_Medicamento_Solicitacao FOREIGN KEY (ID_Medicamento) REFERENCES Medicamentos(ID_Medicamento) 
);

CREATE TABLE Exames ( 
    ID_Exame NUMBER PRIMARY KEY, 
    ID_Paciente NUMBER, 
    Nome_Exame VARCHAR2(100), 
    Data_Realizacao DATE, 
    Resultado VARCHAR2(255), 
    Status VARCHAR2(50), 
    -- Outros campos relevantes 
    CONSTRAINT FK_Paciente_Exame FOREIGN KEY (ID_Paciente) REFERENCES Pacientes(ID_Paciente) 
);

INSERT INTO Pacientes (ID_Paciente, Nome, Data_Nascimento, Endereco, Telefone) 
VALUES (1, 'João Silva', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 'Rua A, 123', '(11) 1234-5678');

INSERT INTO Pacientes (ID_Paciente, Nome, Data_Nascimento, Endereco, Telefone) 
VALUES (2, 'Maria Santos', TO_DATE('1985-08-20', 'YYYY-MM-DD'), 'Avenida B, 456', '(11) 9876-5432');

INSERT INTO Medicos (ID_Medico, Nome, Especialidade, CRM) 
VALUES (1, 'Dr. Carlos Souza', 'Cardiologia', 'CRM12345');

INSERT INTO Medicos (ID_Medico, Nome, Especialidade, CRM) 
VALUES (2, 'Dra. Ana Pereira', 'Pediatria', 'CRM67890');

INSERT INTO Consultas (ID_Consulta, ID_Paciente, ID_Medico, Data_Consulta, Horario_Consulta, Status) 
VALUES (1, 1, 1, TO_DATE('2023-09-25', 'YYYY-MM-DD'), TIMESTAMP '2023-09-25 10:00:00', 'Marcada');

INSERT INTO Consultas (ID_Consulta, ID_Paciente, ID_Medico, Data_Consulta, Horario_Consulta, Status) 
VALUES (2, 2, 2, TO_DATE('2023-09-26', 'YYYY-MM-DD'), TIMESTAMP '2023-09-26 14:30:00', 'Marcada');

INSERT INTO Medicamentos (ID_Medicamento, Nome, Quantidade_Disponivel, Descricao) 
VALUES (1, 'Paracetamol', 100, 'Analgésico e antitérmico');

INSERT INTO Medicamentos (ID_Medicamento, Nome, Quantidade_Disponivel, Descricao) 
VALUES (2, 'Amoxicilina', 50, 'Antibiótico de amplo espectro');

INSERT INTO Solicitacoes (ID_Solicitacao, ID_Paciente, ID_Medicamento, Data_Solicitacao, Quantidade, Status) 
VALUES (1, 1, 1, TO_DATE('2023-09-27', 'YYYY-MM-DD'), 2, 'Pendente');

INSERT INTO Solicitacoes (ID_Solicitacao, ID_Paciente, ID_Medicamento, Data_Solicitacao, Quantidade, Status) 
VALUES (2, 2, 2, TO_DATE('2023-09-28', 'YYYY-MM-DD'), 3, 'Atendida');

INSERT INTO Exames (ID_Exame, ID_Paciente, Nome_Exame, Data_Realizacao, Resultado, Status) 
VALUES (1, 1, 'Hemograma', TO_DATE('2023-09-29', 'YYYY-MM-DD'), 'Normal', 'Concluído');

INSERT INTO Exames (ID_Exame, ID_Paciente, Nome_Exame, Data_Realizacao, Resultado, Status) 
VALUES (2, 2, 'Raio-X de Tórax', TO_DATE('2023-09-30', 'YYYY-MM-DD'), 'Sem anomalias', 'Concluído');

CREATE OR REPLACE FUNCTION Calcular_Idade_Paciente(ID_Paciente NUMBER) RETURN NUMBER IS 
    DataNascimento DATE; 
    Idade NUMBER; 
BEGIN 
    SELECT Data_Nascimento INTO DataNascimento 
    FROM Pacientes 
    WHERE ID_Paciente = Calcular_Idade_Paciente.ID_Paciente; 
 
    Idade := TRUNC(MONTHS_BETWEEN(SYSDATE, DataNascimento) / 12); 
    RETURN Idade; 
END Calcular_Idade_Paciente;
/

SELECT Calcular_Idade_Paciente(1) FROM DUAL;

CREATE OR REPLACE FUNCTION Verificar_Disponibilidade_Medicamento(ID_Medicamento NUMBER, Quantidade Solicitada NUMBER) RETURN BOOLEAN IS 
    QuantidadeDisponivel NUMBER; 
BEGIN 
    SELECT Quantidade_Disponivel INTO QuantidadeDisponivel 
    FROM Medicamentos 
    WHERE ID_Medicamento = Verificar_Disponibilidade_Medicamento.ID_Medicamento; 
 
    IF QuantidadeDisponivel >= QuantidadeSolicitada THEN 
        RETURN TRUE; 
    ELSE 
        RETURN FALSE; 
    END IF; 
END Verificar_Disponibilidade_Medicamento;
/

