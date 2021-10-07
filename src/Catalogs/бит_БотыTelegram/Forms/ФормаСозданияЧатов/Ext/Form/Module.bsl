﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Бот", Бот);
	
	ПолучитьЧатыТекущегоБота();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
   ЗаписатьДанные();
   ОповеститьОбИзменении(Тип("СправочникСсылка.бит_ЧатыTelegram"));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьЗакрыть(Команда)
	
   ЗаписатьДанные();
   ОповеститьОбИзменении(Тип("СправочникСсылка.бит_ЧатыTelegram"));	   
   Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьВсе(Команда)
	
	бит_ТелеграмКлиентСервер.ОбработатьФлаги(ТаблицаЧаты, "Выполнять", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьВсе(Команда)
	
	бит_ТелеграмКлиентСервер.ОбработатьФлаги(ТаблицаЧаты, "Выполнять", 0);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ПолучитьЧатыТекущегоБота();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура создает чаты и назначает пользователям.
//
&НаСервере
Процедура ЗаписатьДанные()

	КоличествоЗаписанных = 0;
	
	Для каждого СтрокаТаблицы Из ТаблицаЧаты Цикл
		
		Если НЕ СтрокаТаблицы.Выполнять Тогда
			Продолжить;
		КонецЕсли; 
		
		ТекЧат = Справочники.бит_ЧатыTelegram.НайтиПоРеквизиту("ИД", СтрокаТаблицы.ИД);
		Если НЕ ЗначениеЗаполнено(ТекЧат) Тогда
			
			НовыйЧат = Справочники.бит_ЧатыTelegram.СоздатьЭлемент();
			НовыйЧат.ИД 				= СтрокаТаблицы.ИД;
			НовыйЧат.ОсновнойБот 		= Бот;
			НовыйЧат.Наименование 		= СтрокаТаблицы.Наименование;
			НовыйЧат.СтатусРегистрации 	= Перечисления.бит_СтатусРегистрацииТелеграм.ОжидаетРегистрации;
			
			НовыйЧат.УстановитьНовыйКод();
			флВыполнено = НовыйЧат.ПроверитьЗаполнение();
			
			Если флВыполнено Тогда
				
				НовыйЧат.Записать();
				
				ТекЧат = НовыйЧат.Ссылка;
				КоличествоЗаписанных = КоличествоЗаписанных + 1;
				
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЦикла; 
	
	ТекстСообщения =  НСтр("ru = 'Записано %1 чатов.'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения,"%1", КоличествоЗаписанных);
	бит_ТелеграмКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	ПолучитьЧатыТекущегоБота();
	
КонецПроцедуры // ЗаписатьДанные()

&НаСервере
Процедура ПолучитьЧатыТекущегоБота()
	
	ТаблицаЧаты.Очистить();
	
	Если НЕ ЗначениеЗаполнено(Бот.Токен) Тогда
	
		ТекстСообщения =  НСтр("ru = 'Выберете бота.'");
		бит_ТелеграмКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	КонецЕсли; 
	
	РезДанные = Справочники.бит_БотыTelegram.НайтиЧаты(Бот.Токен);
	
	Для каждого МодельСтроки Из РезДанные.Данные Цикл
	
		НоваяСтрока = ТаблицаЧаты.Добавить();
		НоваяСтрока.Выполнять = Истина;
		НоваяСтрока.ИД = МодельСтроки.ИД;
		НоваяСтрока.Наименование = МодельСтроки.Наименование;
	
	КонецЦикла;  		
	
КонецПроцедуры

#КонецОбласти