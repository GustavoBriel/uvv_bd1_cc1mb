-- Gustavo Briel de Deus
-- 202306780
-- CC1MB

-- apagar o banco de dados "uvv" caso ele exista
DROP DATABASE IF EXISTS uvv;

-- remover usuário "gustavo", caso ele exista
DROP ROLE IF EXISTS gustavo;

-- cria o usuario "gustavo"
CREATE USER gustavo with CREATEDB INHERIT login password 'senha';

-- cria o banco de dados "uvv" 
CREATE DATABASE uvv 
	OWNER gustavo
	TEMPLATE template0 
	ENCODING 'UTF8'
	LC_COLLATE 'pt_BR.UTF-8'
	LC_CTYPE 'pt_BR.UTF-8'
	ALLOW_CONNECTIONS TRUE;

-- dar todos os privilégios para o usuário "gustavo"
GRANT ALL PRIVILEGES ON DATABASE uvv TO gustavo;

-- faz com que o usuário "gustavo" não precise mais utilizar a senha para entrar no banco de dados "uvv" (altera a conexão)
\c 'dbname=uvv user=gustavo password=senha';

-- cria o Esquema "lojas" e da Autorização ao usuário "gustavo"
CREATE SCHEMA lojas AUTHORIZATION gustavo;

-- ajusta o search path da conexão atual
SET SEARCH_PATH TO lojas, "$user", public;

-- ajusta o search path para o futuro
ALTER USER gustavo SET SEARCH_PATH TO lojas, "$user", public;

-- cria a tabela "clientes"
CREATE TABLE clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT cliente_id PRIMARY KEY (cliente_id)
);

-- comenta a tabela "clientes" e suas colunas
COMMENT ON TABLE clientes IS 'tabela com informações dos clientes';
COMMENT ON COLUMN clientes.cliente_id IS 'número de indentificações dos clientes';
COMMENT ON COLUMN clientes.email IS 'email do cliente para contato';
COMMENT ON COLUMN clientes.nome IS 'nome do cliente';
COMMENT ON COLUMN clientes.telefone1 IS 'primeiro telefone do cliente';
COMMENT ON COLUMN clientes.telefone2 IS 'segundo telefone do cliente';
COMMENT ON COLUMN clientes.telefone3 IS 'terceiro telefone do cliente';

-- cria a tabela "produtos"
CREATE TABLE produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produto_id PRIMARY KEY (produto_id)
);

-- comenta a tabela "produtos" e suas colunas
COMMENT ON TABLE produtos IS 'Tabela com as informações dos produtos';
COMMENT ON COLUMN produtos.produto_id IS 'número de identificação dos produtos';
COMMENT ON COLUMN produtos.nome IS 'nome dos produtos';
COMMENT ON COLUMN produtos.preco_unitario IS 'preço unitário do produto';
COMMENT ON COLUMN produtos.detalhes IS 'detalhes sobre o produto';
COMMENT ON COLUMN produtos.imagem IS 'imagens do produto';
COMMENT ON COLUMN produtos.imagem_mime_type IS 'mime type da imagem do produto';
COMMENT ON COLUMN produtos.imagem_arquivo IS 'onde fica o arquivo da imagem';
COMMENT ON COLUMN produtos.imagem_charset IS 'tipo de codificação dos caracteres da imagem do produto';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao IS 'última vez na qual a imagem do produto foi alterada';

-- cria a tabela "lojas"
CREATE TABLE lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT loja_id PRIMARY KEY (loja_id)
);

-- comenta a tabela "lojas" e suas colunas
COMMENT ON TABLE lojas IS 'tabela com informaçao sobre as lojas';
COMMENT ON COLUMN lojas.loja_id IS 'número de indentificação das lojas';
COMMENT ON COLUMN lojas.nome IS 'nome das lojas';
COMMENT ON COLUMN lojas.endereco_web IS 'endereço do site das lojas';
COMMENT ON COLUMN lojas.endereco_fisico IS 'endereço (logradouro) físicos das lojas';
COMMENT ON COLUMN lojas.latitude IS 'número da latitude na qual a loja fica localizada fisicamente';
COMMENT ON COLUMN lojas.longitude IS 'número da longitude na qual a loja fica localizada fisicamente';
COMMENT ON COLUMN lojas.logo IS 'logo das lojas';
COMMENT ON COLUMN lojas.logo_mime_type IS 'mime-type da imagem da loja';
COMMENT ON COLUMN lojas.logo_arquivo IS 'onde fica localizada o arquivo da logo da loja';
COMMENT ON COLUMN lojas.logo_charset IS 'formato de codificação dos caracteres da logo da loja';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao IS 'última vez na qual a imagem da logo da loja';

-- cria a tabela "pedidos"
CREATE TABLE pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedido_id PRIMARY KEY (pedido_id)
);

-- comenta a tabela "pedidos" e suas colunas
COMMENT ON TABLE pedidos IS 'tabela com informações sobre os pedidos';
COMMENT ON COLUMN pedidos.pedido_id IS 'número de identificação dos pedidos';
COMMENT ON COLUMN pedidos.data_hora IS 'data e hora na qual o pedido foi realizado pelo cliente';
COMMENT ON COLUMN pedidos.cliente_id IS 'número de indentificações dos clientes';
COMMENT ON COLUMN pedidos.status IS 'situação na qual o  andamento do pedido se encontra';
COMMENT ON COLUMN pedidos.loja_id IS 'número de indentificação das lojas';

-- cria a tabela "envios"
CREATE TABLE envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT envio_id PRIMARY KEY (envio_id)
);

-- comenta a tabela "envios" e suas colunas
COMMENT ON TABLE envios IS 'tabela com informaçao sobre os envios';
COMMENT ON COLUMN envios.envio_id IS 'número de identificação dos envios';
COMMENT ON COLUMN envios.loja_id IS 'número de indentificação das lojas';
COMMENT ON COLUMN envios.cliente_id IS 'número de indentificações dos clientes';
COMMENT ON COLUMN envios.endereco_entrega IS 'endereço do cliente no qual ele irá receber seu pedido';
COMMENT ON COLUMN envios.status IS 'situação na qual o  andamento do envio se encontra';

-- cria a tabela "pedidos_itens"
CREATE TABLE pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38),
                CONSTRAINT pedido_id_produto_id_pfk PRIMARY KEY (pedido_id, produto_id)
);

-- comenta a tabela "pedidos_itens" e suas colunas
COMMENT ON TABLE pedidos_itens IS 'tabela com informaçao sobre os itens dos pedidos';
COMMENT ON COLUMN pedidos_itens.pedido_id IS 'número de identificação dos pedidos';
COMMENT ON COLUMN pedidos_itens.produto_id IS 'número de identificação dos produtos';
COMMENT ON COLUMN pedidos_itens.numero_da_linha IS 'número da linha na qual um item de um pedido se encontra';
COMMENT ON COLUMN pedidos_itens.preco_unitario IS 'preço unitário de cada produto do pedido';
COMMENT ON COLUMN pedidos_itens.quantidade IS 'quantidades de produtos em cada pedido';
COMMENT ON COLUMN pedidos_itens.envio_id IS 'número de identificação dos envios';

-- cria a tabela "estoques"
CREATE TABLE estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT estoque_id PRIMARY KEY (estoque_id)
);

-- comenta a tabela "estoques" e suas colunas
COMMENT ON TABLE estoques IS 'tabela com informaçao sobre o estoque';
COMMENT ON COLUMN estoques.estoque_id IS 'número de indentificações do estoque';
COMMENT ON COLUMN estoques.loja_id IS 'número de indentificações das lojas';
COMMENT ON COLUMN estoques.produto_id IS 'número de indentificações dos produtos';
COMMENT ON COLUMN estoques.quantidade IS 'quantidade do produto no estoque';

/* Criação das FK's para as tabelas para o banco de dados "uvv" */

-- cria a FK da tabela "pedidos"
ALTER TABLE pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- cria a FK da tabela "envios"
ALTER TABLE envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- cria a FK da tabela "estoques"
ALTER TABLE estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- cria a FK da tabela "pedidos_itens"
ALTER TABLE pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- cria a FK da tabela "estoques"
ALTER TABLE estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- cria a FK da tabela "envios"
ALTER TABLE envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- cria a FK da tabela "pedidos"
ALTER TABLE pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- cria a FK da tabela "pedidos_itens"
ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- cria a FK da tabela "pedidos_itens"
ALTER TABLE pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/*Adiciona restrições as tabelas determinadas para não serem inseridados dados invalidados nas tabelas */