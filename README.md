<div align="center">

  <h1 align="center">App para Listagem de Exames Médicos</h1>

  <p align="justify">
    Aplicação web para a listagem de exames médicos. Permite a importação de dados de exames a partir de um arquivo para um banco de dados, assim como listagem e visualização dos exames.
    <br/>
  </p>
</div>

### Tecnologias 

- Docker
- Sinatra
- Ruby

### Como Rodar a aplicação?

- Clone o projeto:
```
git clone git@github.com:lucasobx/rebase_labs.git
```

```
cd rebase_labs
```

- Inicie o docker:
```
docker-compose up --build
```
- Importe o arquivo CSV para o banco de dados:
```
docker-compose run app ruby lib/import_from_csv.rb
```

- Acesse a aplicação: http://localhost:3000/