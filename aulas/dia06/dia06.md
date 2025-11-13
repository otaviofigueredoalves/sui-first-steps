# AS REDES DA SUI, ESPECIFICAÇÕES TÉCNICAS  

## LOCALNET: Desenvolvimento isolado
    - Validator: você controla;
    - Performance: ~10000+ TPS;
    - Gas: ILIMITADO;
    - Reset: manual quando quiser.

## DEVNET: Rede experimental
    - Validator: ~10-20(experimental);
    - Performance: ~1000-5000 TPS;
    - Gas: Semanal (dados podem ser perdidos);
    - Reset: Cutting-edge (pode ter bugs).

## TESTNET: Ambiente testável (útil pós devnet)

    - Validator: 50+ (distribuído globalmente);
    - Performance: ~297000 TPS peak;
    - Gas: 99.9%+ qualidade de produção;
    - Reset: Raro (apenas major upgrades).

## MAINNET: Produção

    - Validator: 100+ globalmente;
    - Performance: $1B+;
    - Gas: ~$0.001-0.01;
    - Reset: Comprar em exchanges

# METODOLOGIA RECOMENDADA

## 1. PROTOTIPAGEM (Localnet 1-2 semanas)
    - sui start -with-faucet

## 2. Features (Devnet 2-4 semanas)
    - sui client publish -network devnet

## 3. Testes finais (Testnet 2-3 semanas)
    - sui client publish -network testnet

## 4. Produção (Mainnet - ongoing)
    - sui client publish -network mainnet

# RED FLAGS: QUANDO NÃO USAR

    - Localnet: quando precisa de network effects;
    - Devnet: quando precisar de estabilidade;
    - Testnet: para desenvolvimento experimental;
    - Mainnet: código não auditado ou experimental.

# GERENCIAMENTO DE AMBIENTES

## ADICIONAR TODAS AS REDES
    sui client new-env --alias localnet --rpc http://127.0.0.1:9000
    sui client new-env --alias devnet --rpc https://fullnode.devnet.sui.io:443
    sui client new-env --alias testnet --rpc https://fullnode.testnet.sui.io:443
    sui client new-env --alias mainnet --rpc https://fullnode.mainnet.sui.io:443

## VERIFICAR AMBIENTE ATIVO
    sui client active-env

## ALTERNAR ENTRE REDES
    sui client switch --env testnet

## GERENCIAMENTO DE WALLETS

### Criar adresses para diferentes propósitos
    sui client new-address ed25519 --alias developer
    sui client new-address ed25519 --alias testing
    sui client new-address ed25519 --alias demo

### Alternar entre addresses
    sui client switch --address developer