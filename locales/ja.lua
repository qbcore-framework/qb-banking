local Translations = {
    error = {
        not_give = "与えられたIDにアイテムを与えることができませんでした。",
        givecash = "使い方 /givecash [ID] [金額]",
        wrong_id = "IDが間違っています。",
        dead = "あなたは死んでいます。",
        too_far_away = "あまりにも遠すぎます。",
        not_enough = "指定された金額を所持していません。",
        invalid_amount = "無効な金額が入力されました。"
    },
    success = {
        debit_card = "デビットカードの注文に成功しました。",
        cash_deposit = "$%{value}の現金入金が完了しました。",
        cash_withdrawal = "$%{value}の現金引き出しが完了しました。",
        updated_pin = "デビットカードの暗証番号が正常に変更されました。",
        savings_deposit = "$%{value}が普通預金に入金されました。",
        savings_withdrawal = "$%{value}が普通預金から引き出されました。",
        opened_savings = "普通預金口座が開設されました。",
        give_cash = "ID%{id}のプレイヤーに$%{cash}を送金しました。",
        received_cash = "ID%{id}から$%{cash}を受け取りました。"
    },
    info = {
        bank_blip = "銀行",
        access_bank_target = "銀行窓口",
        access_bank_key = "[E] - 銀行窓口",
        current_to_savings = "当座預金から普通預金への振替",
        savings_to_current = "普通預金から当座預金への振替",
        deposit = "当座預金口座への$%{amount}の入金",
        withdraw = "当座預金から$%{amount}を引き出す",
    },
    command = {
        givecash = "プレイヤーに送金する。"
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
