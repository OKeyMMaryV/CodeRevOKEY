﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Организация") Тогда
		
		ГруппаИ = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
			Список.КомпоновщикНастроек.Настройки.Отбор.Элементы, 
			"ГруппаИ", 
			ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаИ, "Организация", Параметры.Организация, ВидСравненияКомпоновкиДанных.Равно);

		Если Параметры.Свойство("ВидСчетаФактуры") Тогда
				
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			ГруппаИ, "ВидСчетаФактуры", Параметры.ВидСчетаФактуры, ВидСравненияКомпоновкиДанных.Равно);
				
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	
	Если СтрокаТаблицы <> Неопределено Тогда
		ОткрытьДокумент(СтрокаТаблицы.Ссылка);
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьДокумент(Основание)
	
	Закрыть();
	
	ПараметрыФормы = Новый Структура("Основание", Основание);
		
	ОткрытьФорму("Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаДокументаКорректировочная",
		ПараметрыФормы, ВладелецФормы);

КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьДокумент(ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти
