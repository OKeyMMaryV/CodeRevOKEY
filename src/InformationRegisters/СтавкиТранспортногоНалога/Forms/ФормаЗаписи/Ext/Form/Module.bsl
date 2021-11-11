﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокВыбораРегиона(Элементы.ОКТМО.СписокВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораРегиона(СписокРегионов)
	
	СписокРегионов.Очистить();
	
	Макет = РегистрыСведений.СтавкиТранспортногоНалога.ПолучитьМакет("КодыОКТМОСубъектовРФ");
	КодыОКТМОСубъектовРФ = ОбщегоНазначения.ПрочитатьXMLВТаблицу(Макет.ПолучитьТекст()).Данные;
	
	ТаблицаРегионов = АдресныйКлассификатор.СубъектыРФ();
	
	ШаблонПредставления = НСтр("ru='%1 %2'"); //например: "Москва г"
	Для Каждого Регион Из ТаблицаРегионов Цикл
		
		СтрокаСоответствия = КодыОКТМОСубъектовРФ.Найти(Строка(Регион.КодСубъектаРФ), "КодСубъектаРФ");
		
		Если СтрокаСоответствия <> Неопределено Тогда
		
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредставления,
				Регион.Наименование,
				Регион.Сокращение);
			СписокРегионов.Добавить(СтрокаСоответствия.КодОКТМО, Представление);
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Сортируем по наименованию региона
	СписокРегионов.СортироватьПоПредставлению();
	
КонецПроцедуры

