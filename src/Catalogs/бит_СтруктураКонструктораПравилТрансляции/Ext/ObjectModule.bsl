﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияНачалоСобытия(Отказ, ДополнительныеСвойства); 
	
	Если Не ЭтоНовый() И Не ПометкаУдаления=Ссылка.ПометкаУдаления Тогда
		// В случае установки или снятия пометки удаления не производить проверку.
		Возврат;
	КонецЕсли;		
	
	Для каждого СтрокаТаблицы Из КолонкиПравилТрансляции Цикл
		СтрокаТаблицы.НомерКолонки = СтрокаТаблицы.НомерСтроки * 10;
	КонецЦикла; 
	
	Заголовок = СтрШаблон(Нстр("ru = 'Проверка заполнения элемента справочника ""%1""'"), Метаданные().Синоним);
	           	
	Если НЕ ЭтоГруппа Тогда
		
		// Проверим заполнение полей шапки
		СтруктураОбязательных = Новый Структура("Источник,Приемник");
		
		бит_РаботаСМетаданными.ПроверитьЗаполнениеШапки(ЭтотОбъект,СтруктураОбязательных,Отказ,Заголовок);
		
		// Проверим заполнение табличной части
		СтруктураОбязательных = Новый Структура("ИмяКолонки,ИмяРеквизита,ВидКолонки");
		бит_РаботаСМетаданными.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект,"КолонкиПравилТрансляции",СтруктураОбязательных,Отказ,Заголовок);
		    		
	КонецЕсли; 
	
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияПриЗаписи(Отказ, ДополнительныеСвойства, Метаданные().ПолноеИмя());
		
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Функция обновляет типы колонок правил трансляции.  
// 
// Возвращаемое значение:
// флЕстьИзменения - Булево
// 
Функция ОбновитьТипыКолонок() Экспорт

	флЕстьИзменения = Ложь;
	
	ТаблицаРеквизитов = Справочники.бит_СтруктураКонструктораПравилТрансляции.ПолучитьТаблицуРеквизитов(Источник
															                                              , Источник
																										  , Приемник
																										  , УчитыватьКорреспонденцию
																										  , Ложь);
																										  
																										  
	ТаблицаРеквизитов.Колонки.Добавить("ВидКолонки", Новый ОписаниеТипов("ПеречислениеСсылка.бит_ВидыКолонокПравилТрансляции"));
	ТаблицаРеквизитов.ЗаполнитьЗначения(Перечисления.бит_ВидыКолонокПравилТрансляции.РеквизитИсточника, "ВидКолонки");
																										  
	ТабВрем = Справочники.бит_СтруктураКонструктораПравилТрансляции.ПолучитьТаблицуРеквизитов(Неопределено
													                                              , Источник
																								  , Приемник
																								  , УчитыватьКорреспонденцию
																								  , Ложь);
																										  
	Для каждого СтрокаВрем Из ТабВрем Цикл
	
		НоваяСтрока = ТаблицаРеквизитов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаВрем);
		НоваяСтрока.ВидКолонки = Перечисления.бит_ВидыКолонокПравилТрансляции.Прочее;
	
	КонецЦикла; 																									  
																										  
	 ТабВрем = Справочники.бит_СтруктураКонструктораПравилТрансляции.ПолучитьТаблицуРеквизитов(Приемник
													                                              , Источник
																								  , Приемник
																								  , УчитыватьКорреспонденцию
																								  , Истина);
																										  
	  Для каждого СтрокаВрем Из ТабВрем Цикл
		  
		  НоваяСтрока = ТаблицаРеквизитов.Добавить();
		  ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаВрем);
		  НоваяСтрока.ВидКолонки = Перечисления.бит_ВидыКолонокПравилТрансляции.РеквизитПриемника;		  
		  
	  КонецЦикла; 																									  

	  
	  Для каждого СтрокаТаблицы Из КолонкиПравилТрансляции Цикл
	  
	  	   СтрОтбор = Новый Структура("ВидКолонки, ИмяРеквизита", СтрокаТаблицы.ВидКолонки, СтрокаТаблицы.ИмяРеквизита);
		   
		   МассивСтрок = ТаблицаРеквизитов.НайтиСтроки(СтрОтбор);
		   
		   Если МассивСтрок.Количество() > 0 Тогда
			   
			   // Обновляем типы при необходимости
			   ТекСтрока = МассивСтрок[0];
			   
			   Если ТекСтрока.ВидКолонки = Перечисления.бит_ВидыКолонокПравилТрансляции.РеквизитПриемника 
				     И Найти(ТекСтрока.ИмяРеквизита,"Счет") = 0 
					 И Найти(ТекСтрока.ИмяРеквизита,"ИмяВидаСубконто") = 0 Тогда
					 
				   // Для полей приемника необходимо иметь возможность указать строковое выражение.
				   МассивВрем = ТекСтрока.Тип.Типы();
				   МассивВрем.Вставить(0, Тип("Строка"));
				   
				   ТекТип = Новый ОписаниеТипов(МассивВрем, , Новый КвалификаторыСтроки(900));
				   
			   Иначе
				   
				   ТекТип = ТекСтрока.Тип;
				   
			   КонецЕсли; 
			   
			   СтрТипы = бит_ОбщегоНазначения.СтроковоеПредставлениеОписанияТипов(ТекТип);
			   
		   Иначе  
			   
			   // Проверяем корректность указанных типов
			   // типы могли быть удалены.
			   ТекТипы = бит_ОбщегоНазначенияКлиентСервер.ПолучитьОписаниеИзСтроки(СтрокаТаблицы.ТипыЗначенийСтр);
			   СтрТипы = бит_ОбщегоНазначения.СтроковоеПредставлениеОписанияТипов(ТекТипы);
			   ТекТип  = СтрокаТаблицы.ТипыЗначений.Получить();
		   КонецЕсли; 
		   СравнениеЗначений = Новый СравнениеЗначений;
		   
		   //Если СтрокаТаблицы.ТипыЗначенийСтр <> СтрТипы Тогда
		    Если СравнениеЗначений.Сравнить(ТекТип, СтрокаТаблицы.ТипыЗначений.Получить()) <> 0 Тогда   
			   СтрокаТаблицы.ТипыЗначенийСтр = СтрТипы;
			   СтрокаТаблицы.ТипыЗначений = Новый ХранилищеЗначения(ТекТип); 
			   флЕстьИзменения = Истина;
		   КонецЕсли; 
	  КонецЦикла; // КолонкиПравилТрансляции
	  
	  Возврат флЕстьИзменения;
	  
КонецФункции // ОбновитьТипыКолонок()

#КонецОбласти

#КонецЕсли
