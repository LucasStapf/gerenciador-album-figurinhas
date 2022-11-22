--               [ INTEGRANTES DO GRUPO ]                --
--  Carlos Henrique Hannas de Carvalho  NºUSP: 11965988  --
--  Guilherme Azevedo Escudeiro         NºUSP: 11345600  --
--  Leonardo Hannas de Carvalho Santos  NºUSP: 11800480  --
--  Lucas Carvalho Freiberger Stapf     NºUSP: 11800559  --
-----------------------------------------------------------


-- Tabela Cargo --
CREATE TABLE CARGO (
    CPF CHAR(14) NOT NULL,
    CARGO CHAR(4) NOT NULL,
    CONSTRAINT CK_CARGO CHECK (UPPER(CARGO) IN ('ADM', 'USER')),
    CONSTRAINT PK_CARGO PRIMARY KEY (CPF)
);

-- Tabela Administrador --
CREATE TABLE ADMINISTRADOR (
    CPF CHAR(14) NOT NULL,
    NOME VARCHAR2(30) NOT NULL,
    ENDERECO VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_ADM PRIMARY KEY (CPF),
    CONSTRAINT FK_ADM FOREIGN KEY (CPF) 
        REFERENCES CARGO(CPF) 
        ON DELETE CASCADE
);

-- Tabela Colecionador --
CREATE TABLE COLECIONADOR (
    CPF CHAR(14) NOT NULL,
    NOME VARCHAR2(30) NOT NULL,
    ENDERECO VARCHAR2(50) NOT NULL,
    REPUTACAO NUMBER(2, 1) DEFAULT 0,
    CONSTRAINT CK_REPUTACAO CHECK (REPUTACAO >= 0 AND REPUTACAO <= 5),
    CONSTRAINT PK_COLECIONADOR PRIMARY KEY (CPF),
    CONSTRAINT FK_COLECIONADOR FOREIGN KEY (CPF) 
        REFERENCES CARGO(CPF) 
        ON DELETE CASCADE
);

-- Tabela Banimento --
CREATE TABLE BANIMENTO (
    ADMINISTRADOR CHAR(14) NOT NULL,
    COLECIONADOR CHAR(14) NOT NULL,
    DATA_HORA DATE,
    DURACAO INT NOT NULL, -- Numero total de horas
    CONSTRAINT PK_BANIMENTO PRIMARY KEY (ADMINISTRADOR, COLECIONADOR, DATA_HORA),
    CONSTRAINT FK1_BANIMENTO FOREIGN KEY (ADMINISTRADOR) 
        REFERENCES ADMINISTRADOR(CPF),
    CONSTRAINT FK2_BANIMENTO FOREIGN KEY (COLECIONADOR) 
        REFERENCES COLECIONADOR(CPF) 
        ON DELETE CASCADE
);

-- Tabela Avaliacao --
CREATE TABLE AVALIACAO (
    COLECIONADOR CHAR(14) NOT NULL,
    DATA_HORA DATE NOT NULL,
    NOTA NUMBER(2, 1),
    COMENTARIO VARCHAR2(120),
    TIPO CHAR(5) NOT NULL,
    CONSTRAINT CK_TIPO CHECK (UPPER(TIPO) IN ('TROCA', 'VENDA')),
    CONSTRAINT PK_AVALIACAO PRIMARY KEY (COLECIONADOR, DATA_HORA),
    CONSTRAINT FK_AVALIACAO FOREIGN KEY (COLECIONADOR) 
        REFERENCES COLECIONADOR(CPF) 
        ON DELETE CASCADE
);

-- Tabela Album --
CREATE TABLE ALBUM (
    ISBN NUMBER(13, 0) NOT NULL,
    TITULO VARCHAR2(30) NOT NULL,
    NROFIGURINHAS NUMBER(4, 0),
    ADMINISTRATOR CHAR(14) NOT NULL,
    DATA_HORA DATE,
    CONSTRAINT PK_ALBUM PRIMARY KEY (ISBN),
    CONSTRAINT FK_ALBUM FOREIGN KEY (ADMINISTRATOR) 
        REFERENCES ADMINISTRADOR(CPF)
);

-- Tabela Figurinha --
CREATE TABLE FIGURINHA (
    ALBUM NUMBER(13, 0) NOT NULL,
    IDENTIFICADOR VARCHAR2(4) NOT NULL,
    ADMINISTRADOR CHAR(14) NOT NULL,
    DATA_HORA DATE,
    CONSTRAINT PK_FIGURINHA PRIMARY KEY (ALBUM, IDENTIFICADOR),
    CONSTRAINT FK1_FIGURINHA FOREIGN KEY (ALBUM) 
        REFERENCES ALBUM(ISBN) 
        ON DELETE CASCADE,
    CONSTRAINT FK2_FIGURINHA FOREIGN KEY (ADMINISTRADOR) 
        REFERENCES ADMINISTRADOR(CPF)
);

-- Tabela Album Virtual --
CREATE TABLE ALBUM_VIRTUAL (
    COLECIONADOR CHAR(14) NOT NULL,
    ALBUM NUMBER(13, 0) NOT NULL,
    CONSTRAINT PK_ALBUM_VIRTUAL PRIMARY KEY (COLECIONADOR, ALBUM),
    CONSTRAINT FK1_ALBUM_VIRTUAL FOREIGN KEY (COLECIONADOR) 
        REFERENCES COLECIONADOR(CPF) 
        ON DELETE CASCADE,
    CONSTRAINT FK2_ALBUM_VIRTUAL FOREIGN KEY (ALBUM) 
        REFERENCES ALBUM(ISBN)
        ON DELETE CASCADE
);

-- Tabela Album_Virtual_Figurinha --
CREATE TABLE ALBUM_VIRTUAL_FIGURINHA (
    COLECIONADOR CHAR(14) NOT NULL,
    ALBUM_V NUMBER(13, 0) NOT NULL,
    ALBUM_F NUMBER(13, 0) NOT NULL,
    IDENTIFICADOR VARCHAR2(4) NOT NULL,
    CONSTRAINT PK_ALBUM_VIRTUAL_FIGURINHA PRIMARY KEY (COLECIONADOR, ALBUM_V, ALBUM_F, IDENTIFICADOR),
    CONSTRAINT FK1_ALBUM_VIRTUAL_FIGURINHA FOREIGN KEY (COLECIONADOR, ALBUM_V) 
        REFERENCES ALBUM_VIRTUAL(COLECIONADOR, ALBUM)
        ON DELETE CASCADE,
    CONSTRAINT FK2_ALBUM_VIRTUAL_FIGURINHA FOREIGN KEY (ALBUM_F, IDENTIFICADOR) 
        REFERENCES FIGURINHA(ALBUM, IDENTIFICADOR)
        ON DELETE CASCADE
);

-- Tabela Colecionador_Figurinha --
CREATE TABLE COLECIONADOR_FIGURINHA (
    COLECIONADOR CHAR(14) NOT NULL,
    ALBUM NUMBER(13, 0) NOT NULL,
    IDENTIFICADOR VARCHAR2(4) NOT NULL,
    NROFIGURINHA INT NOT NULL,
    CONSTRAINT PK_COLECIONADOR_FIGURINHA PRIMARY KEY (COLECIONADOR, ALBUM, IDENTIFICADOR),
    CONSTRAINT FK1_COLECIONADOR_FIGURINHA FOREIGN KEY (COLECIONADOR) 
        REFERENCES COLECIONADOR(CPF) 
        ON DELETE CASCADE,
    CONSTRAINT FK2_COLECIONADOR_FIGURINHA FOREIGN KEY (ALBUM, IDENTIFICADOR)
        REFERENCES FIGURINHA(ALBUM, IDENTIFICADOR) 
        ON DELETE CASCADE
);

-- Tabela Banca --
CREATE TABLE BANCA (
    CNPJ CHAR(18) NOT NULL,
    ENDERECO VARCHAR2(50) NOT NULL,
    ADMINISTRADOR CHAR(14) NOT NULL,
    CONSTRAINT PK_BANCA PRIMARY KEY (CNPJ),
    CONSTRAINT FK_BANCA FOREIGN KEY (ADMINISTRADOR) 
        REFERENCES ADMINISTRADOR(CPF)  
);

-- Tabela Album_Banca --
CREATE TABLE ALBUM_BANCA (
    ALBUM NUMBER(13,0) NOT NULL,
    BANCA CHAR(18) NOT NULL,
    CONSTRAINT PK_ALBUM_BANCA PRIMARY KEY (ALBUM, BANCA),
    CONSTRAINT FK1_ALBUM_BANCA FOREIGN KEY (ALBUM) 
        REFERENCES ALBUM(ISBN)
        ON DELETE CASCADE,
    CONSTRAINT FK2_ALBUM_BANCA FOREIGN KEY (BANCA) 
        REFERENCES BANCA(CNPJ)
        ON DELETE CASCADE
);

-- Tabela Banca_Figurinha --
CREATE TABLE BANCA_FIGURINHA (
    BANCA CHAR(18) NOT NULL,
    ALBUM NUMBER(13, 0) NOT NULL,
    IDENTIFICADOR VARCHAR2(4) NOT NULL,
    CONSTRAINT PK_BANCA_FIGURINHA PRIMARY KEY (BANCA, ALBUM, IDENTIFICADOR),
    CONSTRAINT FK1_BANCA_FIGURINHA FOREIGN KEY (BANCA) 
        REFERENCES BANCA(CNPJ)
        ON DELETE CASCADE,     
    CONSTRAINT FK2_BANCA_FIGURINHA FOREIGN KEY (ALBUM, IDENTIFICADOR)
        REFERENCES FIGURINHA(ALBUM, IDENTIFICADOR)
        ON DELETE CASCADE
);

-- Tabela Pacote_Fig --
CREATE TABLE PACOTE_FIG (
    COD_BARRAS INT NOT NULL, --PESQUISAR O TAMANHO DO CODIGO DE BARRAS
    QNT_FIGURINHAS NUMBER (2,0) NOT NULL,
    ALBUM NUMBER(13, 0) NOT NULL,
    CONSTRAINT PK_PACOTE_FIG PRIMARY KEY (COD_BARRAS),
    CONSTRAINT FK_PACOTE_FIG FOREIGN KEY (ALBUM)
        REFERENCES ALBUM(ISBN) 
        ON DELETE CASCADE
);

-- Tabela Pacote_Fig_Banca -- 
CREATE TABLE PACOTE_FIG_BANCA (
    PACOTE INT NOT NULL,
    BANCA CHAR(18) NOT NULL,
    CONSTRAINT PK_PACOTE_FIG_BANCA PRIMARY KEY (PACOTE, BANCA),
    CONSTRAINT FK1_PACOTE_FIG_BANCA FOREIGN KEY (PACOTE) 
        REFERENCES PACOTE_FIG(COD_BARRAS)
        ON DELETE CASCADE,
    CONSTRAINT FK2_PACOTE_FIG FOREIGN KEY (BANCA)
        REFERENCES BANCA(CNPJ)
        ON DELETE CASCADE
);

-- Tabela Negociacao --
CREATE TABLE NEGOCIACAO (
    ID INTEGER GENERATED ALWAYS AS IDENTITY,
    COLECIONADOR CHAR(14) NOT NULL,
    ALBUM NUMBER(13, 0) NOT NULL,
    IDENTIFICADOR VARCHAR2(4) NOT NULL,
    DATA_HORA DATE NOT NULL,
    QUANTIDADE INT,
    CONSTRAINT PK_NEGOCIACAO PRIMARY KEY (ID),
    CONSTRAINT SK_NEGOCIACAO UNIQUE (COLECIONADOR, ALBUM, IDENTIFICADOR, DATA_HORA),
    CONSTRAINT FK1_NEGOCIACAO FOREIGN KEY (COLECIONADOR) 
        REFERENCES COLECIONADOR(CPF)
        ON DELETE CASCADE,
    CONSTRAINT FK2_NEGOCIACAO FOREIGN KEY (ALBUM, IDENTIFICADOR)
        REFERENCES FIGURINHA(ALBUM, IDENTIFICADOR)
        ON DELETE CASCADE
);

-- Tabela Venda --
CREATE TABLE VENDA (
    NEGOCIACAO INTEGER NOT NULL,
    COLECIONADOR CHAR(14) NOT NULL,
    VALOR FLOAT NOT NULL,
    LOCAL VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_VENDA PRIMARY KEY (NEGOCIACAO, COLECIONADOR),
    CONSTRAINT FK1_VENDA FOREIGN KEY (NEGOCIACAO)
        REFERENCES NEGOCIACAO(ID)
        ON DELETE CASCADE,
    CONSTRAINT FK2_VENDA FOREIGN KEY (COLECIONADOR) 
        REFERENCES COLECIONADOR(CPF)
        ON DELETE CASCADE
);

-- Tabela Troca --
CREATE TABLE TROCA (
    NEGOCIACAO_1 INTEGER NOT NULL,
    NEGOCIACAO_2 INTEGER NOT NULL,
    CONSTRAINT CK_TROCA CHECK (NEGOCIACAO_1 <> NEGOCIACAO_2),
    LOCAL VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_TROCA PRIMARY KEY (NEGOCIACAO_1, NEGOCIACAO_2),
    CONSTRAINT FK1_TROCA FOREIGN KEY (NEGOCIACAO_1)
        REFERENCES NEGOCIACAO(ID)
        ON DELETE CASCADE,
    CONSTRAINT FK2_TRICA FOREIGN KEY (NEGOCIACAO_2)
        REFERENCES NEGOCIACAO(ID)
        ON DELETE CASCADE
);

-- Tabela Avaliacao_Venda --
CREATE TABLE AVALIACAO_VENDA (
    COLECIONADOR_1 CHAR(14) NOT NULL,
    DATA_HORA DATE NOT NULL,
    NEGOCIACAO INTEGER NOT NULL,
    COLECIONADOR_2 CHAR(14) NOT NULL,
    CONSTRAINT CK_AVALIACAO_VENDA CHECK (COLECIONADOR_1 <> COLECIONADOR_2),
    CONSTRAINT PK_AVALIACAO_VENDA PRIMARY KEY (COLECIONADOR_1, DATA_HORA),
    CONSTRAINT FK1_AVALIACAO_VENDA FOREIGN KEY (COLECIONADOR_1, DATA_HORA)
        REFERENCES AVALIACAO(COLECIONADOR, DATA_HORA)
        ON DELETE CASCADE,
    CONSTRAINT FK2_AVALIACAO_VENDA FOREIGN KEY (NEGOCIACAO, COLECIONADOR_2)
        REFERENCES VENDA(NEGOCIACAO, COLECIONADOR)
        ON DELETE CASCADE
);

-- Tabela Avaliacao_Troca --
CREATE TABLE AVALIACAO_TROCA (
    COLECIONADOR CHAR(14) NOT NULL,
    DATA_HORA DATE NOT NULL,
    NEGOCIACAO_1 INTEGER NOT NULL,
    NEGOCIACAO_2 INTEGER NOT NULL,
    CONSTRAINT PK_AVALIACAO_TROCA PRIMARY KEY (COLECIONADOR, DATA_HORA),
    CONSTRAINT FK1_AVALIACAO_TROCA FOREIGN KEY (COLECIONADOR, DATA_HORA)
        REFERENCES AVALIACAO(COLECIONADOR, DATA_HORA)
        ON DELETE CASCADE,
    CONSTRAINT FK2_AVALIACAO_TROCA FOREIGN KEY (NEGOCIACAO_1, NEGOCIACAO_2)
        REFERENCES TROCA(NEGOCIACAO_1, NEGOCIACAO_2)
        ON DELETE CASCADE
);

-- Tabela Remove_Album --
CREATE TABLE REMOVE_ALBUM (
    ADMINISTRADOR CHAR(14) NOT NULL,
    ALBUM NUMBER(13,0) NOT NULL,
    DATA_HORA DATE,
    CONSTRAINT PK_REMOVE_ALBUM PRIMARY KEY (ALBUM),
    CONSTRAINT FK1_REMOVE_ALBUM FOREIGN KEY (ALBUM)
        REFERENCES ALBUM (ISBN)
        ON DELETE CASCADE,
    CONSTRAINT FK2_REMOVE_ALBUM FOREIGN KEY (ADMINISTRADOR)
        REFERENCES ADMINISTRADOR (CPF)
);

-- Tabela Remove_Fig --
CREATE TABLE REMOVE_FIG (
    ADMINISTRADOR CHAR(14) NOT NULL,
    ALBUM NUMBER(13,0) NOT NULL,
    IDENTIFICADOR VARCHAR2(4) NOT NULL,
    DATA_HORA DATE,
    CONSTRAINT PK_REMOVE_FIG PRIMARY KEY (ALBUM,IDENTIFICADOR),
    CONSTRAINT FK1_REMOVE_FIG FOREIGN KEY (ADMINISTRADOR)
        REFERENCES ADMINISTRADOR (CPF),
    CONSTRAINT FK2_REMOVE_FIG FOREIGN KEY (ALBUM,IDENTIFICADOR)
        REFERENCES FIGURINHA (ALBUM,IDENTIFICADOR)
        ON DELETE CASCADE
);

-- Tabela Remove_Aval --
CREATE TABLE REMOVE_AVAL (
    ADMINISTRADOR CHAR(14) NOT NULL,
    COLECIONADOR CHAR(14) NOT NULL,
    DATA_HORA DATE NOT NULL,
    MOTIVO VARCHAR2(100),
    CONSTRAINT PK_REMOVE_AVAL PRIMARY KEY (COLECIONADOR,DATA_HORA),
    CONSTRAINT FK1_REMOVE_AVAL FOREIGN KEY (ADMINISTRADOR) 
        REFERENCES ADMINISTRADOR (CPF),
    CONSTRAINT FK2_REMOVE_AVAL FOREIGN KEY (COLECIONADOR,DATA_HORA) 
        REFERENCES AVALIACAO (COLECIONADOR,DATA_HORA)
        ON DELETE CASCADE
);