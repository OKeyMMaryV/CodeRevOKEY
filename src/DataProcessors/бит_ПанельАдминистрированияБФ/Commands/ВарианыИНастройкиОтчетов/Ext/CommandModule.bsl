#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Обработка.бит_ПанельАдминистрированияБФ.Форма.ВарианыИНастройкиОтчетов",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.бит_ПанельАдминистрированияБФ.Форма.ВарианыИНастройкиОтчетов" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти
