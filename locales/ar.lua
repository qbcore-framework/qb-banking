local Translations = {
    error = {
        not_give = "لا يمكن إعطاء للايدي المحدد",
        givecash = "/givecash [ID] [AMOUNT]",
        wrong_id = "ايدي خطأ",
        dead = "أنت ميت",
        too_far_away = "أنت بعيد جدًا عنه",
        not_enough = "ليس لديك هذا المبلغ",
        invalid_amount = "مبلغ غير صالح"
    },
    success = {
        debit_card = "لقد طلبت بنجاح البطاقة",
        cash_deposit = "$%{value} لقد نجحت في إيداع نقدي",
        cash_withdrawal = "$%{value} لقد نجحت في سحب",
        updated_pin = "لقد نجحت في تحديث رقم البطاقة الخاصة بك",
        savings_deposit = "$%{value} لقد نجحت في إيداع توفير ",
        savings_withdrawal = "$%{value} لقد نجحت في سحب من الادخار",
        opened_savings = "لقد فتحت بنجاح حساب التوفير",
        give_cash = "$%{cash} ب %{id} أعطى بنجاح ",
        received_cash = "$%{cash} ب %{id} تلقى بنجاح"
    },
    info = { -- you need font arabic -- for exmple im using space font
        bank_blip = "<FONT FACE='space'>ﻚﻨﺒﻟﺍ",
        access_bank_target = "فتح البنك",
        access_bank_key = "[E] فتح البنك",
        current_to_savings = "نقل الحساب الجاري إلى المدخرات",
        savings_to_current = "مدخرات نقل إلى الحساب الجاري",
        deposit = "$%{amount} ايداع",
        withdraw = "$%{amount} سحب",
    },
    command = {
        givecash = "إعطاء نقود للاعب معين",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
