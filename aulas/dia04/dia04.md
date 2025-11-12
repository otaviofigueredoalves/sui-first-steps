# O que são STRUCTS

## STRUCTS = Tipos de dados definidos pelo usuário que encapsulam. Representam algo que você quer criar

### Campos (Fields)
- Dados relacionados logicamente. Em linguagem POO: Os atributos de uma classe

### Abilities
- Permissões sobre operações permitidas. São no total 4 abilities, permissões para que seja possível realizar operações

### Invariantes
- Propriedades sempre verdadeiras. Vinculadas ao objeto de forma ativa.

### Anatomia completa

struct ContaBancaria has key,store {
    id: UID, // identificador único (obrigatório para 'key')
    titular: vector<u8>, // Nome titular
    saldo: u64, // saldo atual
    ativa: bool, // status da conta
    configuracoes: ConfigConta, // Struct aninhada
}

struct ConfigConta has store, copy, drop{
    limite_diario: u64,
    tipo_conta: u8, // 0=corrente, 1=poupança
}

## POR QUE SÃO ESSENCIAIS?

### Type Safety: prevenção de erros

// SEM structs (propenso a erros):

public fun transferir(saldo1: u64, conta1: u64, saldo 2: u64, conta2: u64, valor: u64){
    // Fácil confundir parâmetros!
}

// COM STRUCTS (type-safe)
public fun transferir(origem: &mut ContaBancaria, destino: &mut ContaBancaria, valor: u64)
{
    // Impossível confundir - tipos diferentes garantidos pelo compilador
}

#### ENCAPSULAMENTO
    - Dados privados protegidos por design
    - Interface controlada
    - Complexidade interna escondida

### REUTILIZAÇÃO
    - Compor structs complexas de simples
    - Padrões reutilizáveis entre módulos

## ABILITIES
    [COPY]: duplicar valores - EX: let backup = config;
    [DROP]: descartar valoers - EX: {let temp = data;} - dado temporário que a blockchain pode descartar após consumir o dado, objeto só é usado uma vez;
    [KEY]: storage global - EX: transfer::transfer(obj,addr) - ID único que permite que o objeto seja referenciado, podendo guardar dentro de outro objeto, pode transferir o objeto pra outra pessoa;
    [STORE]: nested storage - Ex: campo de outra struct - Pode criar outra estrutura, como uma NFT

## MATRIZ DE OPERAÇÕES

// COM copy ability
struct Configuracao has copy, drop{
    max_users: u64;
    fee_rate: u64;
}
let config_backup = Configuracao;

// SEM COPY ability (assets financeiros)
struct Coin has key, store{
    id: UID,
    balance: u64
    balance: u64
}

let coin2 = coin1; // ERRO: cannot copy resource 

## COPY CONTROLADA

### QUANDO USAR COPY

// CORRETO: Dados que podem ser duplicadas sem riscos. No exemplo de baixo, não estamos copiando o objeto todo, a estrutura é copiada, mas os atributos são particulares de cada. Nesse caso, temos os metadados do que seria a NFT, isso pode ser copiado

struct MetadadataNFT has copy, drop{
    nome: vector<u8>,
    raridade: u8,
    nivel: u16,
}

struct Coordenadas has copy, drop{
    x: u64,
    y: u64,
}

// PERIGOSO: Assets financeiros NUNCA devem ter copy

struct Coin has key, store{
    id: UID,
    balance: u64
}

// Se tivesse copy:
let coin2 = coin1 // criaria dinheiro do nada!

### QUANDO USAR DROP

struct CacheEntry has drop{
    dados: vector<u8>,
    timestamp: u64,
}

struct ResultadoCalculos has drop{
    soma: u64,
    media: u64,
}

public fun calcular_metricas(){
    let cache = CacheEntry { dados: b"temp", timestamp: 123};
    // cache automaticamente descartado no final
}

### QUANDO NÃO USAR DROP

// PERIGOSO: Capabilities não devem ter drop

struct AdminCap has key, store {
    id: UID,
    permissions: vector<u8>,
}

// Se tivesse drop, admin capability poderia ser perdida acidentalmente

## ABILITY KEY, CIDADANIA BLOCK CHAIN

### REQUISITOS PARA KEY

// VÁLIDO: Primeiro campo deve ser UID

struct MeuObjeto has key{
    id: UID, // OBRIGATÓRIO
    dados: u64, // OPCIONAL
}

// INVÁLIDO: sem UID

struct ObjetoInvalido has key {
    dados: u64 // ERRO: 'key' requires first field 'id: UID'
}

// OPERAÇÕES DE LIFECYCLE

transfer::transfer(obj,recipient); // owned -> owned

transfer::share_object(obj); // owned -> shared

transfer::freeze_object(obj); // owned -> immutable