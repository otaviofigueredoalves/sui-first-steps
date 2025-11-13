module bichinho_digital::bichinho{
    // strings para o nome
    use std::string::String;
    // E de 'objetos' e 'transferências'
    
    // 1. O MOLDE (Struct)
    public struct Bichinho has key, store{
        id: UID,
        nome: String,
        felicidade: u64 // número para medir o quão feliz ele está
    }

    // 2. FÁBRICA
    // Agora pedimos um 'nome' na hora de criar!
    public fun new(nome: String, ctx: &mut TxContext){
        // Criamos o brinquedo
        let meu_bichinho = Bichinho {
            id: object::new(ctx), // mesmo 'número de série',
            nome: nome, // o mesmo que foi dado
            felicidade: 10 // todos começam com 10 de felicidade       
        };
        transfer::transfer(meu_bichinho, tx_context::sender(ctx));
    }

    // 3. AS RECEITAS (ações)

    public fun alimentar(bichinho: &mut Bichinho){
        // pegamos o bichinho emprestado (&mut) e aumentamos sua felicidade
    }
}