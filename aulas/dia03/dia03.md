## MÓDULO = Unidade de compilação + deployment que encapsula
    - Caixinha onde está armazenado todas as informações do contrato. O contrato é o programa em move que fazemos na máquina e queremos enviar pra blockchain;
    - Módulo é a caixinha onde está armazenado tudo isso;
    - Dentro do módulo vamos estruturar o código para enviar pra blockchain

### TYPES
    - Structs: Definições de dados. Como se fosse CLASSES APENAS com propriedades. Structs contém os 'atributos' de um 'personagem';
    - Functions: Lógica de negócio. Fizemos a struct do personagem, agora vamos definir as ações;
    - Constants: Valores imutáveis. Valores que não podem ser modificados. Ex: flags de erros, limite de algo, enumerações... Ex: faço um código que quando der erro referencia a flag ;
    - Resources: Assets digitais seguros. Recursos essenciais do move


## ESTRUTURA BÁSICA

module meu_projeto::contador  {
    use sui::object::{Self, UID};
    use sui::transfer;

    const EMAX_VALUE: u64 = 0;
    
    struct Contador has key {
        id: UID,
        valor: u64
    }
    public fun criar(){
        // implementação
    }
}

// sui client envs vai listar os ambientes que permite com que nosso código se comunique com a blockchain (isso se já tiver configurado)
// 1º estabele o programa ; 2º Cria comandos para buildar seu código, a rede reconhece 3º; compilador verifica se há algum erro;
// A move vai: 1. verificar se o código tá ok; 2. compila o código ; 3. da o feedback (se tiver erro ou não)


## CONFIGURANDO AMBIENTE
sui client
y
enter
0
sui client envs - ver os ambientes
sui client faucet - garantir que o endereço que você está utilizando tenha tokens sui (mesmo que tokens de teste) suficientes para cobrir as taxas das transações. Este processo é essencial para poder implantar pacotes, executar funções e validar sua lógica em qualquer rede que esteja utilizando

## IMPLANTANDO E INTERAGINDO COM UM PACOTE
- Pacotes são um conjunto de módulos escritos em move que definem funções, estruturas e lógica que podem ser executadas por qualquer usuário/contrato
- Para que a lógica possa ser utilizada dentro da rede, o pacote deve ser implantado, ou seja, publicado em uma rede da SUI. Este processo converte o pacote em um objeto imutável que vive na blockchain, com um id único que outros podem referenciar. A partir desse momento, esse código se torna acessível para qualquer conta que queira interagir com ele.
- sui client publish