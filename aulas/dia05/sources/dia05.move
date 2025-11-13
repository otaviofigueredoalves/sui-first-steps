module dia05::dia05{
    public struct Fruta has store{
        id: UID,
    }

    public struct Sanduiche has store{
        id: UID,
    }

    public struct Lancheira has key, store{
        id: UID,
        minha_fruta: Fruta,
        meu_sanduiche: Sanduiche,   
    }
}