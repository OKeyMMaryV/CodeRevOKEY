﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Перечень.МножественныйВыбор = Истина;
	ЗакрыватьПриВыборе = Ложь;
		
	ЗаполнитьПеречень();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПеречень

&НаКлиенте
Процедура ПереченьВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЕстьНовыеЭлементыПеречня = Ложь;
	ВыбранныйЭлемент = ПереченьВыборНаСервере(ВыбраннаяСтрока, ЕстьНовыеЭлементыПеречня);
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОповеститьСписокОВыборе(ВыбранныйЭлемент, ЕстьНовыеЭлементыПеречня);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереченьВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЕстьНовыеЭлементыПеречня = Ложь;
	ВыбранныйЭлемент = ПереченьВыборНаСервере(Значение, ЕстьНовыеЭлементыПеречня);
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОповеститьСписокОВыборе(ВыбранныйЭлемент, ЕстьНовыеЭлементыПеречня);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОповеститьСписокОВыборе(ВыбранныйЭлемент, ЕстьНовыеЭлементыПеречня)

	Если ЕстьНовыеЭлементыПеречня Тогда
		
		ОповеститьОбИзменении(Тип("СправочникСсылка.бит_ВидыВалютныхОпераций"));	
		
	КонецЕсли;
	ОповеститьОВыборе(ВыбранныйЭлемент);

КонецПроцедуры // ОповеститьСписокОВыборе()

&НаСервере
Функция ПереченьВыборНаСервере(Знач ВыбранныеСтроки, ДобавленыНовыеЭлементыПеречня = Ложь)

	СсылкаНаЭлемент = Неопределено;
	
	МассивСсылок = Новый Массив();
	
	Если ТипЗнч(ВыбранныеСтроки) = тип("Массив") Тогда
		
		Для Каждого ИдентификаторСтроки из ВыбранныеСтроки Цикл
			
			Элемент = Перечень.НайтиПоИдентификатору(ИдентификаторСтроки);
			
			Если НЕ ЗначениеЗаполнено(Элемент.Ссылка) Тогда
				
				НовыйЭлементПеречня(Элемент);
				ДобавленыНовыеЭлементыПеречня = Истина;
				
			КонецЕсли;
			
			МассивСсылок.Добавить(Элемент.Ссылка);
			СсылкаНаЭлемент = Элемент.Ссылка;
			
		КонецЦикла;	
		
	ИначеЕсли ТипЗнч(ВыбранныеСтроки) = тип("Число") Тогда	
		
		Элемент = Перечень.НайтиПоИдентификатору(ВыбранныеСтроки);
		
		Если НЕ ЗначениеЗаполнено(Элемент.Ссылка) Тогда
			
			НовыйЭлементПеречня(Элемент);
			ДобавленыНовыеЭлементыПеречня = Истина;
			
		КонецЕсли;
		
		МассивСсылок.Добавить(Элемент.Ссылка);
		СсылкаНаЭлемент = Элемент.Ссылка;
		
	КонецЕсли;

	Если Подбор Тогда
		Возврат МассивСсылок;
	Иначе	
		Возврат СсылкаНаЭлемент;
	Конецесли;
	
КонецФункции

&НаСервере
Функция РанееДобавленныеЭлементы()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	              |	бит_ВидыВалютныхОпераций.Код,
	              |	бит_ВидыВалютныхОпераций.Ссылка
	              |ИЗ
	              |	Справочник.бит_ВидыВалютныхОпераций КАК бит_ВидыВалютныхОпераций";
				   
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПеречень()
	
	Перечень.Очистить();
	
	ЭлементыПеречняИзМакета = Справочники.бит_ВидыВалютныхОпераций.ПереченьВалютныхОпераций();
	
	СуществующиеЭлементыПеречня = РанееДобавленныеЭлементы();
	СуществующиеЭлементыПеречня.Индексы.Добавить("Код");
	
	ЭлементыПеречня = ЭлементыПеречняИзМакета;
	
	Если ЭлементыПеречня.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПоискаРанееСозданных = Новый Структура();
	
	Для Каждого Элемент Из ЭлементыПеречня Цикл
		
		НоваяСтрока = Перечень.Добавить();
		НоваяСтрока.Код   			= Элемент.Код;
		НоваяСтрока.Наименование 	= Элемент.Наименование;
		
		СтруктураПоискаРанееСозданных.Вставить("Код",Элемент.Код);
		НайденныйЭлемент = СуществующиеЭлементыПеречня.НайтиСтроки(СтруктураПоискаРанееСозданных);
		
		Если НайденныйЭлемент.Количество() > 0 Тогда
			
			НоваяСтрока.Ссылка = НайденныйЭлемент[0].Ссылка;
			НоваяСтрока.ЕстьСсылка = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Перечень.Сортировать("ЕстьСсылка Убыв, Код Возр");
		
КонецПроцедуры	

&НаСервере
Процедура НовыйЭлементПеречня(ВыбраннаяСтрока)
	
	ЭлементПеречня = Справочники.бит_ВидыВалютныхОпераций.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(ЭлементПеречня, ВыбраннаяСтрока);
	ЭлементПеречня.НаименованиеПолное = ВыбраннаяСтрока.Наименование;
	ЭлементПеречня.Записать();
	ВыбраннаяСтрока.Ссылка = ЭлементПеречня.Ссылка;
	
КонецПроцедуры	
	
#КонецОбласти