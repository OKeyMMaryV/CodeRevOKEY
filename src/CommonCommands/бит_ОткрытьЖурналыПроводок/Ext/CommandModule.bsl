
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// Сформируем список выбора регистров бухгалтерии.
	СписокВыбора = СформироватьСписокОбъектовДляВыбора();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", "Выбор объекта: Регистр бухгалтерии");
	ПараметрыФормы.Вставить("СписокЗначений", СписокВыбора);
	ПараметрыФормы.Вставить("ВидОбъекта", "РегистрБухгалтерии");
	
	УникальныйИдентификатор = "4d32f4c8-fbfd-42da-bb55-a265f9551998";

	ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораЭлементаПроизвольногоСписка",ПараметрыФормы,,УникальныйИдентификатор,,ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует список имен регистров бухгалтерии БИТ.
// 
&НаСервере
Функция СформироватьСписокОбъектовДляВыбора()
	
	СписокВыбора = бит_УправленческийУчет.СформироватьСписокОбъектовДляВыбора(Перечисления.бит_ВидыОбъектовСистемы.РегистрБухгалтерии, "бит_Дополнительный");
	
	Для Каждого ТекЭлемент Из СписокВыбора Цикл
		ТекЭлемент.Значение = ТекЭлемент.Значение.ИмяОбъекта;
	КонецЦикла;
	
	Возврат СписокВыбора;
	
КонецФункции // СформироватьСписокОбъектовДляВыбора()

#КонецОбласти
