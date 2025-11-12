# HIERARQUIA DE STORAGE

// Level 1: Components (tem store)

struct UserProfile has store, copy, drop{
    username: vector<u8>,
    reputation: u64,
}

// Level 2: Composities (usa components)

struct GameCharacter has key, store{
    id: UID,
    profile: UserProfile, // OK - UserProfile has store
    level: u8,
}

// Level 3: Top-level (usa composities)

struct Game has key{
    id: UID,
    characters: vector<GameCharacter>, // OK - GameCharacter has store
}

## SUI = PRIMEIRA BLOCKCHAIN ORIENTADA A OBJETOS

### NFTS
    - Objetos first-class

### TOKENS
    - objetos com identidade única

### SMART CONTRACTS
    - objetos imutáveis

### ESTADO
    - objetos compartilhados