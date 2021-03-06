
#Область СлужебныйПрограммныйИнтерфейс

#Область РасчетХешСумм

// Пересчитывает хеш-суммы всех упаковок формы и проверяется необходимость перемаркировки.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма проверки и подбора маркируемой продукции.
//
Процедура ПересчитатьХешСуммыВсехУпаковок(Форма) Экспорт

	Если НЕ Форма.ПроверятьНеобходимостьПеремаркировки Тогда
		Возврат;
	КонецЕсли;

	Если Форма.ДетализацияСтруктурыХранения = Перечисления.ДетализацияСтруктурыХраненияТабачнойПродукцииМОТП.Пачки Тогда
		Форма.КоличествоУпаковокКоторыеНеобходимоПеремаркировать = 0;
		ПроверкаИПодборПродукцииМОТПКлиентСервер.ОтобразитьИнформациюОНеобходимостиПеремаркировки(Форма);
		Возврат;
	КонецЕсли;
	
	ТаблицаХешСумм = ПроверкаИПодборПродукцииИС.ПустаяТаблицаХешСумм();
	
	Для Каждого СтрокаДерева Из Форма.ДеревоМаркированнойПродукции.ПолучитьЭлементы() Цикл
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(СтрокаДерева.ТипУпаковки)
		 Или СтрокаДерева.ТипУпаковки = Перечисления.ПрочиеЗоныПересчетаПродукцииИСМП.БлокиБезКоробки Тогда
			ПроверкаИПодборПродукцииИС.РассчитатьХешСуммыУпаковки(СтрокаДерева, ТаблицаХешСумм, Истина);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаПеремаркировки = ПроверкаИПодборПродукцииИС.ТаблицаПеремаркировки(ТаблицаХешСумм);
	
	ПроверкаИПодборПродукцииМОТПКлиентСервер.ПроверитьНеобходимостьПеремаркировки(Форма, ТаблицаПеремаркировки, Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

