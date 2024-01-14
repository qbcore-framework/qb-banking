local Translations = {
    success = {
        withdraw = '引き出しました',
        deposit = '入金しました',
        transfer = '送金しました',
        account = '口座を作成しました',
        rename = '口座名を変更しました',
        delete = '口座を削除しました',
        userAdd = 'ユーザーを追加しました',
        userRemove = 'ユーザーを削除しました',
        card = 'カードを作成しました',
    },
    error = {
        error = 'エラーが発生しました',
        access = '認証されていません',
        account = '口座が見つかりません',
        accounts = '口座数が上限に達しています',
        user = 'ユーザーは既に追加されています',
        noUser = 'ユーザーが見つかりません',
        money = '所持金が足りません',
        pin = 'PINコードが間違っています',
        card = 'キャッシュカードがありません',
    },
    progress = {
        atm = 'ATMを操作中',
    }
}

if GetConvar('qb_locale', 'en') == 'ja' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
