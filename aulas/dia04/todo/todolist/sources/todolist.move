module todolist::todolist{

    use std::string::String;

    public struct TodoList has key, store{
        id: UID, // obrigatório
        items: vector<String>
    }

    // Assinar contexto de uma transação. Como a blockchain consome nossos dados
    public fun new(ctx: &mut TxContext){
        let list = TodoList {
            id: object::new(ctx), // contexto de transaçãO. Tudo que enviamos pra rede é uma transação
            items: vector[],// lista vazia
        };
        transfer::transfer(list, tx_context::sender(ctx)); // aqui estou garantindo que a transferência seja pra mim, ou seja, vinculado à minha conta

    }

    public fun add_item(list: &mut TodoList, item: String){// precisamos utilizar essa função pra adicionar um item
        list.items.push_back(item); // adicionar um item no array items
    }

    public fun remove(list: &mut TodoList, index: u64){
        list.remove(index);
    }
}