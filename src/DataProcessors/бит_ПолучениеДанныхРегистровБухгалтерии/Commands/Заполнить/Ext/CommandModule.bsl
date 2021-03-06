
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ОперацияБух") Тогда
		
		ПараметрыФормы.Вставить("ИмяОбъектаСистемы", "РегистрБухгалтерии.Хозрасчетный");
		
	КонецЕсли; 
	
	Если Найти(ПараметрыВыполненияКоманды.Источник.ИмяФормы, "ФормаСписка") Тогда
		
		ПараметрыФормы.Вставить("Режим", "Множественный");
		
	Иначе
		
		ПараметрыФормы.Вставить("Режим"             , "Одиночный");
		ПараметрыФормы.Вставить("ДокументЗаполнения", ПараметрКоманды);
		
	КонецЕсли; 
	
	ОткрытьФорму("Обработка.бит_ПолучениеДанныхРегистровБухгалтерии.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти

