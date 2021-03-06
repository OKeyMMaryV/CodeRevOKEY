
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// Сформируем список выбора планов счетов.
	СписокВыбора = СформироватьСписокОбъектовДляВыбора();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", "Выбор объекта: План счетов");
	ПараметрыФормы.Вставить("СписокЗначений", СписокВыбора);
	ПараметрыФормы.Вставить("ВидОбъекта", "ПланСчетов");
	
	УникальныйИдентификатор = "4d32f4c8-fbfd-42da-bb55-a265f9551997";
	
	ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораЭлементаПроизвольногоСписка",ПараметрыФормы,,УникальныйИдентификатор,, ПараметрыВыполненияКоманды.НавигационнаяСсылка);	
	
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует список имен планов счетов БИТ.
// 
&НаСервере
Функция СформироватьСписокОбъектовДляВыбора()
	
	СписокВыбора = бит_УправленческийУчет.СформироватьСписокОбъектовДляВыбора(Перечисления.бит_ВидыОбъектовСистемы.ПланСчетов, "бит_Дополнительный");
	
	Для Каждого ТекЭлемент Из СписокВыбора Цикл
		ТекЭлемент.Значение = ТекЭлемент.Значение.ИмяОбъекта;
	КонецЦикла;
	
	Возврат СписокВыбора;
	
КонецФункции // СформироватьСписокОбъектовДляВыбора()

#КонецОбласти
