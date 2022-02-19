# Back-End-TT

> O projeto tem por objetivo simular pesquisas de campo, oferencendo formulários de perguntas para os usuários.

### Ajustes e melhorias

O projeto ainda está em desenvolvimento e as próximas atualizações serão voltadas nas seguintes tarefas:

- [x] desenvolvimento da entidade Usuário (com testes)
- [x] desenvolvimento da autenticação do usuário
- [ ] desenvolvimento da entidade Visitas
- [ ] desenvolvimento da entidade Formulário
- [ ] desenvolvimento da entidade Pergunta
- [ ] desenvolvimento da entidade Resposta

## 💻 Pré-requisitos

Antes de começar, verifique se você atendeu aos seguintes requisitos:

* Você instalou a versão mais recente de `< Ruby / Rails / Yarn >`
* Você tem uma máquina `< Linux >`.
* Você leu `< guia >`.


## ☕ Usando Back-End-TT

Para usar Back-End-TT, siga estas etapas:

* A primeira etapa para o uso do sistema é cadastrar-se no sistema e após se autenticar

1. Comando para se cadastrar:
```
curl --header "Content-Type: application/json" POST --data '{"nome": "user_name", "password": "user_password", "email": "user_email", "cpf": "user_cpf"}' http://localhost:3000/users -v
```
* Atenção, substitua os valores escritos como user_xxxx por suas informações

2. Comando para se autenticar no sistema:
```
curl POST http://localhost:3000/api/v1/authenticate -H"Content-Type: application/json" -d '{"cpf": "user_cpf", "password": "user_password"}' -v
```
* Atenção, substitua os valores escritos como user_xxxx pelas informações dadas no primeiro passo

* Neste passo vai ser fornecido o "JWT_token" necessário para executar as funcionalidades do sistema


## Funcionalidades de Usuário

3. listar usuários cadastrados (há um limite de 100 usuários listados por paginação para evitar lentidão do sistema):

```
curl --header "Authorization: Bearer JWT_token" http://localhost:3000/api/v1/users -v
```


4. editar usuários:

```
curl --header "Authorization: Bearer JWT_token" --header "Content-Type: application/json" --request PUT --data '{"user": { "nome": user_name, "email": user_email, "password": user_password, "cpf": user_cpf }}' http://localhost:3000/api/v1/users/user_id -v
```

* Atenção, lembrar de substituir o user_id na url

5. deletar usuário:

```
curl --header "Authorization: Bearer JWT_token" --header "Content-Type: application/json" --request DELETE http://localhost:3000/api/v1/users/user_id -v
```

* Atenção, lembrar de substituir o user_id na url





## 🤝 Colaboradores

<table>
  <tr>
    <td align="center">
      <a href="#">
        <img src="https://avatars.githubusercontent.com/u/55093303?s=400&u=89f708771cae690428170a701a7b1ec2bc6ce98c&v=4" width="100px;" alt="Foto do David Manuel no GitHub"/><br>
        <sub>
          <b>David Manuel</b>
        </sub>
      </a>
    </td>
  </tr>
</table>