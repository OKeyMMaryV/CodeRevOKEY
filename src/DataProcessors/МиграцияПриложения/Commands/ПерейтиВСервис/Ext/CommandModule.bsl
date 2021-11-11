﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Форма = ПараметрыПриложения["ТехнологияСервиса.МиграцияПриложений.ФормаПереходВСервис"];
	Если Форма = Неопределено Тогда
		ОткрытьФорму("Обработка.МиграцияПриложения.Форма.ПереходВСервис", , ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	ИначеЕсли Не Форма.Открыта() Тогда
		Форма.Открыть();
	Иначе
		Форма.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
