// "module todolist::todolist"
// Isso é o nome da sua caixa de LEGO e o nome da sua
// planta de instruções. "Caixa: todolist, Planta: todolist"
module todolist::todolist{

    // "use std::string::String;"
    // "Quero usar 'Peças de Palavra' (String) da biblioteca
    // padrão (std) para escrever minhas tarefas."
    use std::string::String;
    // (Também vamos precisar disso para a função de remover!)
    use std::vector;

    /*
     "public struct TodoList has key, store"
     "Aqui está a PLANTA (Struct) do meu brinquedo.
     - 'public': Todo mundo pode ver essa planta.
     - 'TodoList': O nome do brinquedo é "Lista de Tarefas".
     - 'has key, store': Nossos adesivos mágicos!
       - 🔑 'key': Este brinquedo é um Objeto de verdade.
         Ele pode ser seu e viver no playground (blockchain).
       - 📦 'store': Este brinquedo pode ser guardado
         dentro de outras caixas (embora não estejamos
         fazendo isso aqui).
    */
    public struct TodoList has key, store{
        // "id: UID"
        // O "número de série" único. Obrigatório
        // por causa do adesivo 'key'.
        id: UID,
        // "items: vector<String>"
        // O "corpo" do nosso brinquedo. É uma "fila" (vector)
        // onde vamos guardar nossas "Peças de Palavra" (as tarefas).
        items: vector<String>
    }

    /*
     "public fun new(ctx: &mut TxContext)"
     Esta é a "Receita da Fábrica" (fun) para criar
     uma lista nova.
     - 'public': Qualquer um pode usar essa receita.
     - 'ctx: &mut TxContext': Para construir qualquer
       coisa no playground, você precisa de uma
       "Permissão de Construção" (TxContext). O '&mut'
       significa que vamos "carimbar" essa permissão.
    */
    public fun new(ctx: &mut TxContext){
        // "let list = TodoList { ... }"
        // Estamos pegando o molde (Struct) e criando
        // um brinquedo de verdade.
        let list = TodoList {
            // "id: object::new(ctx)"
            // Pedimos ao playground (usando a permissão 'ctx')
            // um "número de série" (id) novo e único.
            id: object::new(ctx),
            // "items: vector[]"
            // Começamos com a fila de tarefas vazia.
            items: vector[],
        };
        /*
         "transfer::transfer(list, tx_context::sender(ctx));"
         Este é o passo final!
         - 'transfer': Estamos "movendo" a propriedade.
         - 'list': O brinquedo que acabamos de criar.
         - 'tx_context::sender(ctx)': Para quem vamos dar?
           Para o "remetente" (sender) que usou a "permissão" (ctx).
           Ou seja, VOCÊ! O brinquedo agora é seu.
        */
        transfer::transfer(list, tx_context::sender(ctx));
    }

    /*
     "public fun add_item(list: &mut TodoList, item: String)"
     A receita para "Adicionar uma Tarefa".
     - 'list: &mut TodoList': Para adicionar um item, você
       não me *dá* sua lista para sempre. Você me
       *empresta* ela com permissão de "pode mudar" (&mut).
     - 'item: String': Você me dá a "Peça de Palavra"
       (a tarefa) que quer adicionar.
    */
    public fun add_item(list: &mut TodoList, item: String){
        // "list.items.push_back(item);"
        // Pegamos a fila de tarefas (list.items) e
        // "empurramos para o fim" (push_back) a nova tarefa (item).
        vector::push_back(&mut list.items, item); // (Sintaxe mais correta)
    }

    /*
     "public fun remove(list: &mut TodoList, index: u64)"
     A receita para "Remover uma Tarefa".
     - 'list: &mut TodoList': De novo, você me empresta
       sua lista para eu poder alterá-la.
     - 'index: u64': Você me diz *qual* tarefa remover,
       dando o "número da posição" dela na fila (o índice).
    */
    public fun remove(list: &mut TodoList, index: u64){
        // "list.remove(index);"
        // Opa! Notei uma coisinha aqui. A função de "remover"
        // não é da lista inteira (list), mas sim da "fila" (items).
        // O jeito certo seria usar a função da biblioteca 'vector':
        vector::remove(&mut list.items, index);
        // Isso pega a fila 'items' e remove o item na posição 'index'.
        // O item removido é simplesmente... destruído (dropped).
    }
}