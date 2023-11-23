# QB-Banking

## Features
- Handles all player interaction with bank/job/gang/shared accounts
- ATM and bank card integration
- Shared accounts between players
- Auto creation of job/gang accounts on bank first open
- Boss-only access to job/gang accounts

## Exports
```lua
exports['qb-banking']:ExportName() -- replace export name with desired from below and needed arguments
```

### CreatePlayerAccount

Creates a new shared account for a player

```lua
    CreatePlayerAccount(
        playerId, -- id of the player account is being created for
        accountName, -- name of the account, must be a string
        accountBalance, -- balance of the account on creation, must be a number
        json.encode({'LCC00307', 'LCC00308'}) -- table of users on account by citizenid
    )
```
### CreateJobAccount

Creates a new job type account, this is automatically done so shouldn't need this

```lua
    CreateJobAccount(
        accountName, -- name of the account, must be a string
        accountBalance, -- balance of the account on creation, must be a number
    )
```
### CreateGangAccount

Creates a new gang type account, this is automatically done so shouldn't need this

```lua
    CreateGangAccount(
        accountName, -- name of the account, must be a string
        accountBalance, -- balance of the account on creation, must be a number
    )
```
### AddMoney

Adds money to an account by name, checks for regular account first
If playerId is provided and a regular account isn't found then it will check for shared account

```lua
    AddMoney(
        accountName, -- name of the account, must be a string
        accountBalance, -- balance of the account on creation, must be a number
        reason -- optional, must be a string
    )
```
### RemoveMoney

Removes money from an account by name, checks for regular account first
If playerId is provided and a regular account isn't found then it will check for shared account

```lua
    RemoveMoney(
        accountName, -- name of the account, must be a string
        accountBalance, -- balance of the account on creation, must be a number
        reason -- optional, must be a string
    )
```
### GetAccount

Returns all the information for the specified account by name

```lua
    GetAccount(
        accountName, -- name of the account
    )
```
### GetAccountBalance

Returns just the balance of the specified account by name

```lua
    GetAccountBalance(
        accountName, -- name of the account
    )
```
### CreateBankStatement

This will create a statement for a specified account

```lua
    CreateBankStatement(
        playerId, -- id of the player to create the statement for
        account, -- name of the shared account, must be a string
        amount, -- amount of the transaction, must be a number
        reason, -- reason for the transaction , must be a string
        statementType, -- type of statement, must be a string 'withdraw' or 'deposit'
        accountType -- type of account, must be a string 'player', 'shared', 'job', 'gang'
    )
```

# License

    QBCore Framework
    Copyright (C) 2021 Joshua Eger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>