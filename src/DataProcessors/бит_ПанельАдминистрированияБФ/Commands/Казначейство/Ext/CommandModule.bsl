﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Обработка.бит_ПанельАдминистрированияБФ.Форма.Казначейство",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.бит_ПанельАдминистрированияБФ.Форма.Казначейство" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
		
КонецПроцедуры

#КонецОбласти
