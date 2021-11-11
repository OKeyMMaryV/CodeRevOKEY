﻿
&НаКлиенте
Процедура ЗаполнитьРегистр(Команда)
	
	Если Вопрос("Обработка может выполняться длительное время. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРегистрСервер();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРегистрСервер()
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Документы.Ссылка,
	|	рс_ДокументыПоID.ID
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг КАК Документы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.рс_ДокументыПоID КАК рс_ДокументыПоID
	|		ПО (рс_ДокументыПоID.Регистратор = Документы.Ссылка)
	|ГДЕ
	|	Документы.ОК_ID_Разноска <> """"
	|	И Документы.ОК_ID_Разноска <> ""    -    ""
	|	И Документы.ОК_ID_Разноска <> ""0""
	|	И рс_ДокументыПоID.ID ЕСТЬ NULL ";
	
	Для Каждого Тип Из Метаданные.ПодпискиНаСобытия.рс_ПриЗаписиОбработкаID.Источник.Типы() Цикл
		
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		ИмяТаблицы = ОбъектМетаданных.Имя;
		
		Если ОбщегоНазначенияБП.ЕстьРеквизитДокумента("ОК_ID_Разноска", ОбъектМетаданных) Тогда
			ИмяРеквизитID = "Документы.ОК_ID_Разноска";
		ИначеЕсли ОбщегоНазначенияБП.ЕстьРеквизитДокумента("ID", ОбъектМетаданных) Тогда
			ИмяРеквизитID = "Документы.ID";
		//1c-izhtc spawn 07.08.15 (
		ИначеЕсли ОбщегоНазначенияБП.ЕстьРеквизитДокумента("УдалитьИжтиси_ОК_ID_Разноска", ОбъектМетаданных) Тогда
			ИмяРеквизитID = "Документы.УдалитьИжтиси_ОК_ID_Разноска";
		//1c-izhtc spawn 07.08.15 )
		Иначе
			ИмяРеквизитID = "";
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапроса;
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПоступлениеТоваровУслуг", ИмяТаблицы);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Документы.ОК_ID_Разноска", ИмяРеквизитID);
		
		ТаблицаЗапрос = Запрос.Выполнить().Выгрузить();
		
		ОбработатьТаблицуДокументов(ТаблицаЗапрос);
		
		// дополнительный запрос для ID в ТЧ документа ПоступлениеТоваровУслуг
		Если ИмяТаблицы = "ПоступлениеТоваровУслуг" Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	Документы.Ссылка
			|ИЗ
			|	Документ.ПоступлениеТоваровУслуг КАК Документы
			|ГДЕ
			|	Документы.ОК_ID_ВТЧ = ИСТИНА";
			ТаблицаЗапрос = Запрос.Выполнить().Выгрузить();
			
			ОбработатьТаблицуДокументов(ТаблицаЗапрос);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьТаблицуДокументов(ТаблицаЗапрос)
	
	ОбъектовНаТранзакцию = 100;
	
	НачатьТранзакцию();
	
	КолВсего = ТаблицаЗапрос.Количество();
	Ном = 0;
	
	Для Каждого СтрокаЗапрос Из ТаблицаЗапрос Цикл
		
		Ном = Ном + 1;
		
		//Состояние("Обработка " + Ном + "/" + КолВсего + " " + СтрокаЗапрос.Ссылка);
		
		ДокументОбъект = СтрокаЗапрос.Ссылка.ПолучитьОбъект();
		рс_ОбщийМодуль.рс_ПриЗаписиОбработкаID(ДокументОбъект, Ложь);
		
		Если Ном % ОбъектовНаТранзакцию = 0 Тогда
			ЗафиксироватьТранзакцию();
			НачатьТранзакцию();
		КонецЕсли;
		
		//ОбработкаПрерыванияПользователя();
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры
