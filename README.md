# Trabalho M2 - Engenharia e Qualidade de Software

[![CI/CD](https://github.com/jcf-junior/trabalho-eqs/actions/workflows/ci.yaml/badge.svg)](https://github.com/jcf-junior/trabalho-eqs/actions/workflows/ci.yaml)

[![Postman Tests](https://github.com/jcf-junior/trabalho-eqs/actions/workflows/postmanTests.yaml/badge.svg)](https://github.com/jcf-junior/trabalho-eqs/actions/workflows/postmanTests.yaml)

[![Build Image](https://github.com/jcf-junior/trabalho-eqs/actions/workflows/build.yaml/badge.svg)](https://github.com/jcf-junior/trabalho-eqs/actions/workflows/build.yaml)

## Integrar Postman e DevOps

API REST com dados fictícios da universidade Universidade Politécnica de Viana do Castelo (UniPVC).

A API usa Node, Express e PostgreSQL. Uma collection do Postman testa a API na pipeline de GitHub Actions, com o Newman CLI.

### Requisitos

- [Git](https://git-scm.com/)
- [Node.js 22](https://nodejs.org/) e npm
- [Docker](https://docs.docker.com/get-docker/) com Docker Compose

## Instalação

```bash
git clone https://github.com/jcf-junior/trabalho-eqs.git
cd trabalho-eqs
npm ci
```

O `npm ci` instala as dependências e ativa o hook de pre-commit (Husky).

## Executar com Docker Compose

Esta opção executa a API e a base de dados em contentores, como na pipeline.

1. Construir a imagem da API:

   ```bash
   docker build -t ghcr.io/jcf-junior/trabalho_m2:latest .
   ```

   Se não construir a imagem, o Docker Compose tenta descarregar a imagem do GitHub Container Registry.

2. Inicie os serviços:

   ```bash
   docker compose up -d
   ```

3. Confirme que a API está disponível:

   ```bash
   curl http://localhost:3333/
   ```

   A resposta é `"Welcome to UniPVC Fake API!"`.

Comandos úteis:

| Comando                      | Resultado                                   |
| ---------------------------- | ------------------------------------------- |
| `docker compose logs -f api` | Mostra os logs da API.                      |
| `docker compose down`        | Para os serviços. Os dados ficam no volume. |
| `docker compose down -v`     | Para os serviços e apaga os dados.          |

O PostgreSQL só executa o `postgres/init.sql` quando o volume está vazio. Para repor os dados iniciais, execute `docker compose down -v` e depois `docker compose up -d`.

Depois de alterar o código, construa a imagem outra vez (passo 1) e execute `docker compose up -d`.

## Executar a API com Node.js

Esta opção é mais rápida para desenvolvimento, porque não é necessário construir a imagem depois de cada alteração. A base de dados continua num contentor.

O serviço `postgres` do `docker-compose.yml` não publica a porta 5432. Por isso, inicie um contentor separado.

1. Pare o Docker Compose, se estiver em execução:

   ```bash
   docker compose down
   ```

2. Inicie a base de dados.

   Linux, macOS ou Git Bash:

   ```bash
   MSYS_NO_PATHCONV=1 docker run -d --name trabalho_m2-db-dev \
     -e POSTGRES_DB=app -e POSTGRES_PASSWORD=postgres \
     -p 5432:5432 \
     -v "$(pwd)/postgres/init.sql:/docker-entrypoint-initdb.d/init.sql:ro" \
     postgres:17
   ```

   PowerShell:

   ```powershell
   docker run -d --name trabalho_m2-db-dev `
     -e POSTGRES_DB=app -e POSTGRES_PASSWORD=postgres `
     -p 5432:5432 `
     -v "${PWD}/postgres/init.sql:/docker-entrypoint-initdb.d/init.sql:ro" `
     postgres:17
   ```

3. Inicie a API:

   ```bash
   npm start
   ```

A API usa estas variáveis de ambiente. Os valores por omissão funcionam com o contentor do passo 2.

| Variável      | Valor por omissão |
| ------------- | ----------------- |
| `PORT`        | `3333`            |
| `DB_HOST`     | `localhost`       |
| `DB_PORT`     | `5432`            |
| `DB_NAME`     | `app`             |
| `DB_USER`     | `postgres`        |
| `DB_PASSWORD` | `postgres`        |

Para apagar a base de dados de desenvolvimento:

```bash
docker rm -f trabalho_m2-db-dev
```

## Endpoints

| Método   | Caminho                          | Descrição                                 |
| -------- | -------------------------------- | ----------------------------------------- |
| `GET`    | `/`                              | Mensagem de boas-vindas                   |
| `GET`    | `/alunos`                        | Lista os alunos                           |
| `GET`    | `/alunos/:id`                    | Mostra um aluno                           |
| `POST`   | `/alunos`                        | Cria um aluno                             |
| `DELETE` | `/alunos/:id`                    | Apaga um aluno e as inscrições dele       |
| `POST`   | `/alunos/:id/disciplinas`        | Inscreve um aluno numa disciplina         |
| `DELETE` | `/alunos/:id/disciplinas/:sigla` | Apaga uma inscrição                       |
| `GET`    | `/professores`                   | Lista os professores                      |
| `GET`    | `/professores/:id`               | Mostra um professor                       |
| `POST`   | `/professores`                   | Cria um professor                         |
| `DELETE` | `/professores/:id`               | Apaga um professor                        |
| `GET`    | `/cursos`                        | Lista os cursos                           |
| `GET`    | `/cursos/:id`                    | Mostra um curso                           |
| `POST`   | `/cursos`                        | Cria um curso                             |
| `DELETE` | `/cursos/:id`                    | Apaga um curso                            |
| `GET`    | `/disciplinas`                   | Lista as disciplinas                      |
| `GET`    | `/disciplinas/:sigla`            | Mostra uma disciplina                     |
| `POST`   | `/disciplinas`                   | Cria uma disciplina                       |
| `DELETE` | `/disciplinas/:sigla`            | Apaga uma disciplina e as suas inscrições |

Campos obrigatórios nos pedidos `POST`:

| Caminho                   | Campos                                              |
| ------------------------- | --------------------------------------------------- |
| `/professores`            | `nome`, `habilitacoes`, `email`                     |
| `/cursos`                 | `nome`, `sigla`, `professor_coordenador_id`, `tipo` |
| `/disciplinas`            | `sigla`, `nome`, `professor_responsavel_id`         |
| `/alunos`                 | `nome`, `curso_id`, `email`                         |
| `/alunos/:id/disciplinas` | `sigla`                                             |

Exemplo:

```bash
curl -X POST http://localhost:3333/professores \
  -H "Content-Type: application/json" \
  -d '{"nome": "Maria Rocha", "habilitacoes": "Doutoramento", "email": "mrocha@unipvc.pt"}'
```

No Windows PowerShell, use `curl.exe` em vez de `curl`.

Códigos de resposta:

| Código | Significado                                                          |
| ------ | -------------------------------------------------------------------- |
| `200`  | Pedido `GET` com sucesso.                                            |
| `201`  | Registo criado.                                                      |
| `204`  | Registo apagado.                                                     |
| `400`  | Dados em falta ou inválidos, ou referência a um registo inexistente. |
| `404`  | O registo não existe.                                                |
| `409`  | O registo já existe, ou outros registos ainda usam o registo.        |

## Testes com Postman

A collection está em `postman-api-collection/collection.json`. A API tem de estar em execução antes dos testes.

Execute os testes com o Newman:

```bash
npx newman run postman-api-collection/collection.json
```

A collection cria os seus próprios dados de teste e apaga-os no fim. Pode executar a collection várias vezes na mesma base de dados.

Para testar a API noutro endereço, altere a variável `baseUrl`:

```bash
npx newman run postman-api-collection/collection.json --env-var baseUrl=http://localhost:4000
```

Para usar a aplicação do Postman, importe o ficheiro `collection.json` (**File > Import**) e execute a collection com o **Collection Runner**.

## Lint e formatação

| Comando                | Resultado                                   |
| ---------------------- | ------------------------------------------- |
| `npm run lint`         | Verifica o código com o ESLint.             |
| `npm run format:check` | Verifica a formatação com o Prettier.       |
| `npm run format`       | Corrige a formatação de todos os ficheiros. |

Antes de cada commit, o hook de pre-commit executa o lint e a formatação nos ficheiros alterados.

## Pipeline

| Workflow            | Quando executa              | O que faz                                                            |
| ------------------- | --------------------------- | -------------------------------------------------------------------- |
| `ci.yaml`           | Em cada push e pull request | Executa o lint e verifica a formatação.                              |
| `postmanTests.yaml` | Em cada push e pull request | Inicia a API com Docker Compose e executa a collection com o Newman. |
| `build.yaml`        | Em cada push para `main`    | Calcula a versão, constrói a imagem e publica-a no GHCR.             |
| `deploy.yaml`       | Manualmente                 | Instala uma versão em `preprod` ou `prod`.                           |

## Estrutura do projeto

```text
.
├── .github/workflows/      Workflows de GitHub Actions
├── postgres/init.sql       Esquema e dados iniciais da base de dados
├── postman-api-collection/ Collection do Postman
├── src/
│   ├── app.js              Ponto de entrada da API
│   ├── config/db.js        Ligação ao PostgreSQL
│   ├── controllers/        Lógica dos endpoints
│   └── routes/             Definição das rotas
├── docker-compose.yml
└── dockerfile
```
