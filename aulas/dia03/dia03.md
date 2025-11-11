## MÓDULO = Unidade de compilação + deployment que encapsula
    - Caixinha onde está armazenado todas as informações do contrato. O contrato é o programa em move que fazemos na máquina e queremos enviar pra blockchain;
    - Módulo é a caixinha onde está armazenado tudo isso;
    - Dentro do módulo vamos estruturar o código para enviar pra blockchain

### TYPES
    - Structs: Definições de dados. Como se fosse CLASSES APENAS com propriedades. Structs contém os 'atributos' de um 'personagem';
    - Functions: Lógica de negócio. Fizemos a struct do personagem, agora vamos definir as ações;
    - Constants: Valores imutáveis. Valores que não podem ser modificados. Ex: flags de erros, limite de algo, enumerações... Ex: faço um código que quando der erro referencia a flag ;
    - Resources: Assets digitais seguros. Recursos essenciais do move