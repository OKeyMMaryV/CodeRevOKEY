﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// --------Отчеты----------->
	
	Перем КлючТекущихНастроек;
	
	Если Не Параметры.Свойство("НастраиваемыйОбъект") Тогда
		
		КлючОбъекта = Параметры.КлючОбъекта;	
		КлючТекущихНастроек = Параметры.КлючТекущихНастроек;		
		 
		ТипНастройки = Перечисления.бит_ТипыСохраненныхНастроек.Отчеты;
		НастраиваемыйОбъект = КлючОбъекта;
			
		РаботаЧерезМенеджер = Истина;
		
	// --------Отчеты-----------|
    Иначе
		
		НастраиваемыйОбъект = Параметры.НастраиваемыйОбъект;
		
		Если Параметры.Свойство("ТипНастройки") Тогда   		
			 ТипНастройки = Параметры.ТипНастройки; 		
		КонецЕсли; 
		
		Если Параметры.Свойство("КлючОбъекта") Тогда  		
			КлючОбъекта = Параметры.КлючОбъекта; 		
		КонецЕсли;  
	
	КонецЕсли;  
	
	Если ПустаяСтрока(КлючОбъекта) Тогда	
		КлючОбъекта = Справочники.бит_СохраненныеНастройки.СформироватьКлючОбъекта(НастраиваемыйОбъект);	
	КонецЕсли;
	
	ЗаполнитьКэшЗначений(); 	
	
	ОбновитьТаблицуНастроек(КлючТекущихНастроек);
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаСохраненныеНастройки

&НаКлиенте
Процедура ТаблицаСохраненныеНастройкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьНастройку();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	ВыбратьНастройку();
	
КонецПроцедуры // КомандаВыбрать()

&НаКлиенте
Процедура КомандаОбновить(Команда)
		
	ОбновитьТаблицуНастроек();
	
КонецПроцедуры // КомандаОбновить()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьКэшЗначений()

	фКэшЗначений = Новый Структура;
	
	КэшПеречислений = Новый Структура;
	КэшПеречислений.Вставить("бит_ТипыСохраненныхНастроек", бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_ТипыСохраненныхНастроек));
	
	ФКэшЗначений.Вставить("Перечисления", КэшПеречислений);	

КонецПроцедуры // ЗаполнитьКэшЗначений()

&НаСервере
Процедура ОбновитьТаблицуНастроек(КлючТекущихНастроек = Неопределено)

	НомерРазделителя 			= Найти(НастраиваемыйОбъект, "/");
	ЕстьРазделитель 			= НомерРазделителя <> 0;
	ПолноеИмяОтчета  			= ?(ЕстьРазделитель, Лев(НастраиваемыйОбъект, НомерРазделителя-1), НастраиваемыйОбъект);
	СтруктураДоступности 	   	= бит_ОтчетыСервер.ПроверитьДоступностьВариантовНастроек(ПолноеИмяОтчета, ЕстьРазделитель);
	фСписокНеДоступныхНастроек  = СтруктураДоступности.СписокНеДоступныхНастроек;
	КлючНастройкиПоУмолчанию 	= бит_ОтчетыСервер.НайтиНастройкуПоУмолчаниюДляОбъекта(КлючОбъекта, Истина);
	
	ИдТекущейСтроки = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТипНастройки"	   , ТипНастройки);
	Запрос.УстановитьПараметр("НастраиваемыйОбъект", НастраиваемыйОбъект);	
	Запрос.УстановитьПараметр("КлючОбъекта"		   , КлючОбъекта);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	бит_СохраненныеНастройки.Ссылка,
	|	бит_СохраненныеНастройки.Ответственный,
	|	бит_СохраненныеНастройки.КлючНастройки
	|ИЗ
	|	Справочник.бит_СохраненныеНастройки КАК бит_СохраненныеНастройки
	|ГДЕ
	|	бит_СохраненныеНастройки.ТипНастройки = &ТипНастройки
	|	И бит_СохраненныеНастройки.НастраиваемыйОбъект = &НастраиваемыйОбъект
	|	И бит_СохраненныеНастройки.КлючОбъекта = &КлючОбъекта
	|
	|УПОРЯДОЧИТЬ ПО
	|	бит_СохраненныеНастройки.Наименование
	|АВТОУПОРЯДОЧИВАНИЕ
	|";
				   
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	ТаблицаСохраненныеНастройки.Очистить();
	Пока Выборка.Следующий() Цикл
		
		Если фСписокНеДоступныхНастроек.НайтиПоЗначению(Выборка.КлючНастройки) <> Неопределено Тогда
			Продолжить;		
		КонецЕсли;
		НоваяСтрока = ТаблицаСохраненныеНастройки.Добавить();
		НоваяСтрока.СохраненнаяНастройка 	= Выборка.Ссылка;
		НоваяСтрока.Ответственный 			= Выборка.Ответственный;
		НоваяСтрока.КлючНастройки 			= Выборка.КлючНастройки;
		
		НоваяСтрока.ИспользоватьПриОткрытии = Выборка.КлючНастройки = КлючНастройкиПоУмолчанию;
		
		Если КлючТекущихНастроек = Выборка.КлючНастройки Тогда
			ИдТекущейСтроки = НоваяСтрока.ПолучитьИдентификатор();		
		КонецЕсли;
		
	КонецЦикла; 
	
	Если ИдТекущейСтроки <> Неопределено Тогда
		Элементы.ТаблицаСохраненныеНастройки.ТекущаяСтрока = ИдТекущейСтроки;
	КонецЕсли;

КонецПроцедуры // ОбновитьТаблицуНастроек()

&НаКлиенте
Процедура ВыбратьНастройку()
	
	ТекущаяСтрока = Элементы.ТаблицаСохраненныеНастройки.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		
		Закрыть();
		
	Иначе	
		
		Если РаботаЧерезМенеджер Тогда
			
			ВыборНастроек = Новый ВыборНастроек(ТекущаяСтрока.КлючНастройки);
			Закрыть(ВыборНастроек);

		Иначе
			
			Если ТипНастройки = фКэшЗначений.Перечисления.бит_ТипыСохраненныхНастроек.НастройкиПанелиИндикаторов 
			    ИЛИ ТипНастройки = фКэшЗначений.Перечисления.бит_ТипыСохраненныхНастроек.Обработки
				ИЛИ ТипНастройки = фКэшЗначений.Перечисления.бит_ТипыСохраненныхНастроек.Отчеты Тогда  
				
				Закрыть(ТекущаяСтрока.СохраненнаяНастройка);
				
			Иначе	
				
			    ВыборНастроек = Новый ВыборНастроек(ТекущаяСтрока.КлючОбъекта);
				
				Закрыть(ВыборНастроек);
			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли; 

КонецПроцедуры // ВыбратьНастройку()

#КонецОбласти
