# DIA 2
## HISTÓRIA DO MOVE: TIMELINE

### Meta Diem Project -> 2018-2019
    - Equipe: ex-engenheiros microsoft, apple, vmware;
    - Objetivo: moeda digital para 3+ bilhões de usuários;
    - Problema: linguagens existentes inadequadas para assets digitais. Resolver particularidades de outras redes

### Design e Implementação -> 2019-2020
    - Lead: Sam Blackshear(PHD Carnegie Mellon)
    - Co-lead: Evan Cheng (LLVM Creator, Apple)
    - Inspiração: Rust ownership + Linear Types

### Open source e SUI
    - Meta abandona Diem: tiveram problema de regular como a meta diem acontecia. Desvinculam do Diem e voltam com a SUI
    - Equipe forma Mysten Labs
    - Move adaptado para SUI Blockchain

## POR QUE MOVE FOI NECESSÁRIA?

### Solidty - Fatal Flaws (Erros graves)

    - Integer Overflow: "balance = balance -1": pode variar números gigantes. Vulnerabilidade a cerca das variáveis que são expostas e é possível modifica-las para causar um erro na operação, seja duplicar variável ou alterar o valor para 0, -1...

    - Reentrancy: $60M+ roubados (DAO Hack 2016): Contrato envia transação pra alguém e hacker vai manipular a transação de alguma forma, enquanto ela não for validada na rede o hacker fica fazendo aquela manipulação removendo o dinheiro do contrato. Na SUI não tem esse tipo de vulnerabilidade. Não dá pra perder tokens em uma transação

    - Token Loss: código pode "esquecer" de Rastrear supply

### RUST - Próximo mas não suficiente
    - Ownership mas sem primitivos financeiros;
    - Pode duplicar valores econômicos sem perceber;
    - Sem gas metering ou storage global;
    - O problema é que o rust não foi feito pra contratos inteligente então possui lacunas.


### O QUE A SUI RESOLVE?
    - Quando é um erro de programação por causa do código, o MOVE não permite que aquele código rode;
    - A move por si só dificulta que esse tipo de processo não aconteça, há várias travas de segurança nativas. Ao contrário de outras linguagens...;
    - Ele tem a versatilidade do RUST, mas sem as lacunas

## FILOSOFIA "SECURITY FIRST" DO MOVE

### RESOURCE TYPES: Mathematical Foundation

- O próprio dev se sente mais seguro de programar, pois o próprio compilador entende que você quer fazer uma operação e de que tem que deixar TUDO explícito.

#### Linearity
    - Cada resource usado exatamente uma vez. Cada objeto possui um ID único. Forte tratamento de recursos
#### No Copy
    - Resources não podem ser duplicados. Não dá pra copiar algo que possa perder a propriedade sobre aquele ativo
#### No Drop
    - Resources não podem ser perdidos.
#### Move Semantics
    - Transferência explícita de propriedade


## EXEMPLO DE CÓDIGO 01(ALGO IMPOSSÍVEL EM MOVE)

public fun impossible_duplication(coin: Coin<SUI>):(Coin<SUI>,Coin<SUI>) {
    (coin, coin) // ERRO DE COMPILAÇÃO: use of moved value -> Isso fere o princípio do ID ÚNICO!!!
}

## Modelo de Resources: Fundação

### Resource = Linear Type com 4 invariantes
- r:Resource.use_count(r) = 1; (Usado somente uma vez);
- r:Resource.copy(r); (Não pode ser copiado);
- r:Resource.drop(r); (Não pode ser perdido);
- r:Resource.owner(r); (Proprietário único): Como tudo é único e possui seu identificador único, sua assinatura também é única, você é proprietário daquele recurso, o único validador. Não é possível copiar ou perder o recurso. Você possui suas operações de forma muito clara na rede e tem um feedback rápido enquanto programa.

#### COMPARAÇÕES

- Javascript: "let token2 = token1" (copia, dobra supply);
- Move: "let token2 = token1" (ERRO - não compila);

### Linear Type System na Prática

public fun resource_example(treasury: &mut TreasuryCap<MYCOIN>, ctx: &mut TxContext){
    let coin1 = coin::mint(treasury, 100, ctx); // cria 100 tokens;
    let coin2 = coin::mint(treasury, 50, ctx); // cria 50 tokens;

    // VÁLIDO: Combining resources
    coin::join(&mut coin1, coin2); // coin2 consumindo, coin1 agora tem 150

    // INVÁLIDO: Tentar usar coin2 novamente
    let value = coin::value(&coin2); // ERRO: coin2 foi moved

    // VÁLIDO: usar o resultado
    transfer::public_transfer(coin1, @recipient); // coin1 consumido
}

## MOVE vs Outras linguagens: comparação

[ASPECTO]         |  [SOLIDTY]                                 |      [MOVE]                                                    |
ASSETS            | Podem ser perdidos (travamento na rede)    |    Impossível perder, pois tem vários recursos de segurança    |
DUPLICAÇÃO        | Possível(bugs)                             |    Impossível por design                                       |
REENTRANCY        | Manual prevention                          |    Naturalmente segura                                         |
VERIFICAÇÃO       | Ferramentas externaas                      |    Built-in prover                                             |
BUGS FINANCEIROS  | Comuns ($18B+perdidos)                     |    Prevenidos pelo compilador                                  |

- Na move a transação ACONTECE ou NÃO ACONTECE. Ou seja, não tem como acontecer esses erros como acontece nas outras redes7
- Imagina só ter 200 moedas e você quer aplicar algo para duplicar +200 moedas. Ou até se 200 moedas for seu limite e você cria um código que envia 200 moedas pra duas pessoas. A MOVE não permite isso


## SUI MOVE X SUI ORIGINAL

### MOVE ORIGINAL (DIEM): Recursos imutáveis

public fun split_old_coin<T>(coin: OldCoin<T>, amount: u64): (OldCoin<T>, OldCoin<T>){
    let OldCoin { value } = coin; // destrói original
    (OldCoin) { value: amount }, OldCoin { value: value - amount })
} // Para "MUDAR" precisa DESTRUIR e criar. Nisso, eles perceberam que se pra um objeto mudar é preciso destruir e recriar, causava uma certa barreira que é a VELOCIDADE, não vai tornar ele rápido de conseguir ser modificado

### SUI MOVE: Objetos mutáveis + Ids únicos

public fun join_coins<T>(coin1: &mut Coin<T>, coin2: Coin<T>){
    balance::join(&mut coin1.balance, coin2.balance);
    // coin1 mantém mesmo ID, valor aumentado;
} // Modificação in-place preservando identidade

// Ocorreu uma vulnerabilidade na SUI, mas não que não foi causado pela linguagem MOVE, pois nesse caso estavam sendo usado recursos de terceiros e quando você faz essa terceirização, abre sua 'casa' para vulnerabilidades. 90% de todos os hackeios as causas são as mesmas. Dev mal intencionado, terceirização... Porém NUNCA uma CHAIN foi hackeada realmente, os hackeios são mais engenharia social


### DEMO: Resource Safety na prática

#### Criando Coin seguro e tentando quebrar a segurança (não permitido)

module safe_demo::coin{
    struct SafeCoin has key{
        id: UID,
        value: u64,
    }
}

public fun create_coin(value: u64, ctx: &mut TxContext): SafeCoin{
    SafeCoin {id: object::new(ctx, value)}
}

public fun join(coin1: &mut SafeCoin, coin2: SafeCoin){
    let SafeCoin {ìd, value} = coin2;
    object::delete(id);
    coin1.value = coin1.value + value;
}

## OWNERSHIP E MOVE SEMANTICS

### Padrões de transferência

// Direct transfer: por exemplo, pego 150 coins e quero enviar pra fulano. Uso essa estrutura para fazer uma transição direta pra ele

public fun direct_transfer(coin: Coin<SUI>, recipient: address){
    transfer::public_transfer(coin, recipient); // coin movido para recipient
}  

// Conditional Transfer: pegar uma quantidade de token e se tal condição for verdadeira realiza a transação para outra pessoa. Se não, ela volta pra mim ou poderia também colocar pra transferir pra outra pessoa

public fun conditional_transfer(coin: Coin<SUI>, conditional: bool, recipient: address, sender: address){
    if (condition){
        transfer::public_transfer(coin, recipient);
    } else {
        transfer::public_transfer(coin, sender); // return to sender
    }
}

// Pra você ver como tudo deve ser explícito e que os recursos devem ser bem direcionados!

## PREVENÇÃO DE DOUBLE-SPENDING

### CENÁRIO: Alice tenta apagar Bob e Carol com mesma moeda

public fun attempt_double_spend(coin: Coin<SUI>){
    transfer::public_transfer(coin, @bob); // coin movido para bob;
    transfer::public_transfer(coin, @carol); // ERRO: use of moved value
}

### SOLUÇÃO LEGÍTIMA

public fun legitimate_split(coin: &mut Coin<SUI>, amount: u64, ctx: &mut TxContext){
    let split_coin = coin::split(coin, amount, ctx); // Divide explicitamente;

    transfer::public_transfer(split_coin, @bob); // Bob gets split
    transfer::public_transfer(*coin, @carol) // Carol gets remainder
    // Total conservado: nenhum dinheiro criado ou perdido pois aqui, em uma única transação é dívido o valor. Ou seja, se foi definido valor 50, cada um vai receber 25
}


## CAPABILITES E ACCESS CONTROL

### Hot Potato Pattern

// Propriedades de consumir recursos

struct HotPotato {// Note: sem 'key', 'store' abilities}{
    value: u64
}

public fun create_hot_potato(value: u64): HotPotato{
    HotPotato { value }
}

public fun consume_hot_potato(potato: HotPotato): u64 {
    let HotPotato { value } = potato;  Deve ser destruturado value 
}

## HABILIDADES

Elas são "crachás" que você dá à sua struct (classe) para dizer ao compilador o que é permitido.

As 4 Habilidades são:

    key: O crachá mais importante. Diz: "Esta struct é um Objeto Sui de verdade. É um 'recurso' que pode ser salvo na blockchain e ter um dono."

    store: Diz: "Esta struct pode ser guardada dentro de outra struct." (Ex: um struct Capacete com store pode ser guardado dentro de um struct Inventario).

    copy: Diz: "Esta struct pode ser copiada (clone)."

    drop: Diz: "Esta struct pode ser destruída (unset)."

O "Pulo do Gato": Para um NFT ou uma Moeda, você define assim: struct MeuNFT has key, store { ... }

Percebeu o que falta? Ela NÃO tem copy e NÃO tem drop.

O próprio compilador Move agora te proíbe de duplicar ou destruir um MeuNFT. É uma regra da linguagem. É isso que a torna segura. Você é forçado a transferir a propriedade dele para alguém (transfer::transfer(meuNft, ...)).