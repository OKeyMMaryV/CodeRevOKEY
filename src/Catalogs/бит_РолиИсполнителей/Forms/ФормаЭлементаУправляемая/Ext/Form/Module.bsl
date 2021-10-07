﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
 	
 	
 	// Вызов механизма защиты
 	
 	
 	Если Отказ Тогда
 		Возврат;
 	КонецЕсли; 
	
	МаксКоличествоОбъектов = 3;	
	// Заполнение таблицы объектов адресации
	ИнициализироватьТабОбъектыАдресации();
	             		
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Проверка на наличие пропусков в заполнении аналитики.
	флПредПустая   = Ложь;
	флЕстьПропуски = Ложь;
	Для каждого СтрокаТаблицы Из ТабОбъектыАдресации Цикл
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.Вид) И флПредПустая = Истина Тогда
			
			флЕстьПропуски = Истина;
			
		КонецЕсли; 
		
		флПредПустая = ?(ЗначениеЗаполнено(СтрокаТаблицы.Вид),Ложь,Истина);
		
	КонецЦикла; 
	
	Если флЕстьПропуски Тогда
		
		ТекстСообщения = НСтр("ru = 'Аналитики необходимо заполнять без пропусков!'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Отказ = Истина;
	
	КонецЕсли; 
	
	Если НЕ Отказ Тогда
		
		// Синхронизация ТабОбъектыАдресации и табличной части ОбъектыАдресации.
		Если Модифицированность Тогда
		
			СинхронизироватьТаблицы(ТекущийОбъект);
		
		КонецЕсли; 
	
	КонецЕсли; // НЕ Отказ
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТабОбъектыАдресации

&НаКлиенте
Процедура ТабОбъектыАдресацииПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Модифицированность = Истина;
	
	ТекущаяСтрока = Элементы.ТабОбъектыАдресации.ТекущиеДанные;
	ТекущаяСтрока.Изменено = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТабОбъектыАдресацииВидОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ТабОбъектыАдресации.ТекущиеДанные;
	ТекущаяСтрока.Обязательный = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет ТабОбъектыАдресации, расположенную на форме 
// по данным табличной части ОбъектыАдресации.
// 
&НаСервере
Процедура ИнициализироватьТабОбъектыАдресации()
	
	СтрСиноним = НСтр("ru = 'Объект адресации №'");
	
	Для й = 1 По МаксКоличествоОбъектов Цикл
		
		Имя = "ОбъектАдресации_"+й;
		
		СтрОтбор = Новый Структура("Имя", Имя);
		МассивСтрок = Объект.ОбъектыАдресации.НайтиСтроки(СтрОтбор);
		
		Если МассивСтрок.Количество() =0 Тогда
			
			НоваяСтрока = ТабОбъектыАдресации.Добавить();
			НоваяСтрока.Имя     = Имя;
			НоваяСтрока.Синоним = СтрСиноним+й;
			
		Иначе	
			
			СтрокаТаблицы = МассивСтрок[0];
			НоваяСтрока   = ТабОбъектыАдресации.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			НоваяСтрока.Синоним = СтрСиноним+й;
			
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры // ИнициализироватьТабОбъектыАдресации()

// Процедура синхронизирует табличную часть ОбъектыАдресации и таблицу ТабОбъектыАдресации.
// 
&НаСервере
Процедура СинхронизироватьТаблицы(ТекущийОбъект)
	
	Для каждого СтрокаТаблицы Из ТабОбъектыАдресации Цикл
		
		СтрОтбор = Новый Структура("Имя", СтрокаТаблицы.Имя);
		
		МассивСтрок = ТекущийОбъект.ОбъектыАдресации.НайтиСтроки(СтрОтбор);
		
		Если МассивСтрок.Количество() = 0 Тогда
			
			// Нет строки с таким именем - нужно создать.
			
			Если ЗначениеЗаполнено(СтрокаТаблицы.Вид) Тогда
				
				НоваяСтрока = ТекущийОбъект.ОбъектыАдресации.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
				
			КонецЕсли; 
			
		Иначе	
			
			// В таб. части есть строка с таким именем
			
			СтрокаТабЧасти = МассивСтрок[0];
			
			Если ЗначениеЗаполнено(СтрокаТаблицы.Вид) Тогда
				
				// Синхронизируем реквизиты
				ЗаполнитьЗначенияСвойств(СтрокаТабЧасти, СтрокаТаблицы);
				
			Иначе	
				
				// Удаляем строку таб. части
				ТекущийОбъект.ОбъектыАдресации.Удалить(СтрокаТабЧасти);
				
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЦикла;  // ТабОбъектыАдресации
	
КонецПроцедуры // СинхронизироватьТаблицы()

#КонецОбласти

