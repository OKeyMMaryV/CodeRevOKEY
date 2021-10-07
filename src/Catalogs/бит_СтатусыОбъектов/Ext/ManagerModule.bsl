﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает объектам системы, соответствующий предопределенной групп статусов.
//
// Параметры:
//
// ГруппаСтатусов - СправочникСсылка.бит_СтатусыОбъектов
//
// Возвращаемое значение:
// ОбъектСистемы - СправочникСсылка.бит_ОбъектыСистемы
//
Функция ОбъектСистемыВГруппе(ГруппаСтатусов) Экспорт
	
	ОбъектСистемы 		   = Справочники.бит_ОбъектыСистемы.ПустаяСсылка();
	ОбъектыСистемыВГруппах = ОбъектыСистемыВПоставляемыхГруппах();
	РезультаПоиска 		   = ОбъектыСистемыВГруппах.Найти(ГруппаСтатусов, "Статус");
	
	Если РезультаПоиска <> Неопределено Тогда
		ОбъектСистемы = РезультаПоиска.Объект;
	КонецЕсли; 
	
	Возврат ОбъектСистемы;
	
КонецФункции

// Возвращает соответствие предопределенных групп статусов объектам системы.
//
// Возвращаемое значение:
//  Соответствие - Ключ - предопределенная группа, Значение - СправочникСсылка.бит_ОбъектыСистемы.
//
Функция ОбъектыСистемыВПоставляемыхГруппах() Экспорт
	
	ОбъектыСистемыВГруппах = Новый ТаблицаЗначений(); 
	ОбъектыСистемыВГруппах.Колонки.Добавить("Статус", 	 Новый ОписаниеТипов("СправочникСсылка.бит_СтатусыОбъектов"));
	ОбъектыСистемыВГруппах.Колонки.Добавить("ПолноеИмя", ОбщегоНазначения.ОписаниеТипаСтрока(250));
	ОбъектыСистемыВГруппах.Колонки.Добавить("Объект", 	 Новый ОписаниеТипов("СправочникСсылка.бит_ОбъектыСистемы"));
	
	Менеджер = Справочники.бит_СтатусыОбъектов;
	
	ДобавитьВОбъектыСистемы(Менеджер.СостоянияЗадач, 	 					  Метаданные.Задачи.бит_уп_Задача, 							 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СостоянияПроцессов, 					  Метаданные.БизнесПроцессы.бит_уп_Процесс,					 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыАктуализацияБюджета, 			  Метаданные.Документы.бит_АктуализацияБюджета, 			 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыБюджетнойОперации, 				  Метаданные.Документы.бит_БюджетнаяОперация, 				 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыВалютныйСвоп, 					  Метаданные.Документы.бит_ВалютныйСвоп, 					 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыДополнительныеУсловияПоДоговору,  Метаданные.Документы.бит_ДополнительныеУсловияПоДоговору,  ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыЗаявкаНаИзменение,				  Метаданные.Документы.бит_мдм_ЗаявкаНаИзменение, 			 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыЗаявкаНаУдаление, 				  Метаданные.Документы.бит_мдм_ЗаявкаНаУдаление, 			 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыКорректировкаБюджета, 		 	  Метаданные.Документы.бит_ЗаявкаНаРасходованиеСредств, 	 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыКорректировкаКонтрольныхЗначений, Метаданные.Документы.бит_КорректировкаКонтрольныхЗначений, ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыОперации, 						  Метаданные.Документы.бит_ОперацияУправленческий, 			 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыПретензийИсков, 				  Метаданные.Документы.бит_Претензия, 						 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыПротоколовРасхожденийБюджета, 	  Метаданные.Документы.бит_ПротоколРасхожденийБюджета,		 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыРеестраПлатежей, 				  Метаданные.Документы.бит_РеестрПлатежей, 					 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыФормыВводаБюджета, 				  Метаданные.Документы.бит_ФормаВводаБюджета, 				 ОбъектыСистемыВГруппах);

	// ++ БП
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыВерсияОтчета, 					  Метаданные.Документы.бит_ВерсияОтчета, 					 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыЗаявкаНаРасходованиеСредствОбщая, Метаданные.Документы.бит_ЗаявкаНаРасходованиеСредствОбщая, ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыЗаявкиНаЗакупку, 				  Метаданные.Документы.бит_мто_ЗаявкаНаЗакупку, 			 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыЗаявкиНаПотребность, 			  Метаданные.Документы.бит_мто_ЗаявкаНаПотребность, 		 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыПлатежнаяПозиция, 				  Метаданные.Документы.бит_ПлатежнаяПозиция, 				 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыПроектДоговора,					  Метаданные.Документы.бит_ПроектДоговора, 					 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыРасходнаяПозиция, 				  Метаданные.Документы.бит_РасходнаяПозиция,				 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыСправкиОПодтверждающихДокументах, Метаданные.Документы.бит_СправкаОПодтверждающихДокументах, ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыЗаявкаНаЗатраты,				  Метаданные.Документы.бит_ЗаявкаНаЗатраты, 				 ОбъектыСистемыВГруппах);
	ДобавитьВОбъектыСистемы(Менеджер.СтатусыЗаявкиНаРасходованиеСредств, 	  Метаданные.Документы.бит_ЗаявкаНаРасходованиеСредств, 	 ОбъектыСистемыВГруппах);
	// -- БП 
	
	ЗаполнитьОбъектыСистемы(ОбъектыСистемыВГруппах);
	
	Возврат ОбъектыСистемыВГруппах;

КонецФункции

Процедура УстановитьШрифтАвто() Экспорт
	
	ШрифтПоУмолчаниюАвто = Новый Шрифт;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	бит_СтатусыОбъектов.Ссылка КАК Ссылка,
	|	бит_СтатусыОбъектов.Оформление КАК Оформление
	|ИЗ
	|	Справочник.бит_СтатусыОбъектов КАК бит_СтатусыОбъектов";
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		 		
		Если НЕ ЗначениеЗаполнено(Выборка.Оформление) Тогда
			Продолжить;		
		КонецЕсли;
		
		СпрОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		СтрОформления = Выборка.Оформление.Получить();
		Если ТипЗнч(СтрОформления) = Тип("Структура") Тогда
			
			// НастройкаОформления: Шрифт, ЦветФона, ЦветТекста, + ШрифтАвто
			Если НЕ СтрОформления.Свойство("ШрифтАвто") Тогда
				
				Если СтрОформления.Свойство("Шрифт") И СтрОформления.Шрифт.Вид = ВидШрифта.WindowsШрифт Тогда
					// Шрифт "Авто"
			    	СтрОформления.Вставить("ШрифтАвто", Истина);
					СтрОформления.Вставить("Шрифт"    , ШрифтПоУмолчаниюАвто);
				Иначе
			      	СтрОформления.Вставить("ШрифтАвто", Ложь);
				КонецЕсли;
				
				// Запись нового оформления
				СпрОбъект.Оформление = Новый ХранилищеЗначения(СтрОформления);
				// Запись справочника
				бит_ОбщегоНазначения.ЗаписатьСправочник(СпрОбъект, , "Ошибки"); 				
				
			КонецЕсли; 
		КонецЕсли;		
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьОбъектыСистемыПриПереходеНаНовуюВерсию() Экспорт
		
	ОбъектыСистемыВГруппах = Справочники.бит_СтатусыОбъектов.ОбъектыСистемыВПоставляемыхГруппах();

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Таблица", ОбъектыСистемыВГруппах);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Статус КАК Статус,
	|	Таблица.ПолноеИмя КАК ПолноеИмя,
	|	Таблица.Объект КАК Объект
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	&Таблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтатусыОбъектов.Ссылка КАК Ссылка,
	|	Таблица.Объект КАК Объект
	|ИЗ
	|	Справочник.бит_СтатусыОбъектов КАК СтатусыОбъектов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Таблица КАК Таблица
	|		ПО СтатусыОбъектов.Родитель = Таблица.Статус
	|			И (НЕ СтатусыОбъектов.ЭтоГруппа)
	|			И (СтатусыОбъектов.Родитель.Предопределенный)
	|			И СтатусыОбъектов.Объект <> Таблица.Объект";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтатусОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(СтатусОбъект, Выборка);
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СтатусОбъект);
	КонецЦикла;
	
КонецПроцедуры
 
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьВОбъектыСистемы(Статус, ОбъектМетаданных, ОбъектыСистемыВГруппах)

	СтрокаТаблицы = ОбъектыСистемыВГруппах.Добавить();
	СтрокаТаблицы.Статус 	= Статус;
	СтрокаТаблицы.ПолноеИмя = ОбъектМетаданных.ПолноеИмя();

КонецПроцедуры

Процедура ЗаполнитьОбъектыСистемы(ОбъектыСистемыВГруппах)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Таблица", ОбъектыСистемыВГруппах);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Таблица.Статус КАК Статус,
	|	Таблица.ПолноеИмя КАК ПолноеИмя,
	|	Таблица.Объект КАК Объект
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	&Таблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Статус КАК Статус,
	|	Таблица.ПолноеИмя КАК ПолноеИмя,
	|	ОбъектыСистемы.Ссылка КАК Объект
	|ИЗ
	|	Таблица КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.бит_ОбъектыСистемы КАК ОбъектыСистемы
	|		ПО Таблица.ПолноеИмя = ОбъектыСистемы.ИмяОбъектаПолное";
	
	РезультатЗапроса	   = Запрос.Выполнить();
	ОбъектыСистемыВГруппах = РезультатЗапроса.Выгрузить();			
	
КонецПроцедуры
 
#КонецОбласти 
 
#КонецЕсли
