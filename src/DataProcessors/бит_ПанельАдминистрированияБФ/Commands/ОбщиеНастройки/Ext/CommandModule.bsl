#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Обработка.бит_ПанельАдминистрированияБФ.Форма.ОбщиеНастройки",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.бит_ПанельАдминистрированияБФ.Форма.ОбщиеНастройки" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
		
КонецПроцедуры

#КонецОбласти
