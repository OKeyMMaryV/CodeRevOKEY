﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки	 - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПолучитьПараметрыОССервер(СтрокаТаблицы, ДокОбъект, Отказ = Ложь, НеИзменяемыеПараметры = Ложь, МожноПерезаполнятьДанныеПоОС) Экспорт

	ЭтоМассив = ТипЗнч(СтрокаТаблицы) = Тип("Массив");
	
	Если ЭтоМассив Тогда
		
		МассивОС = СтрокаТаблицы;
		
	Иначе	
		
		МассивОС = СтрокаТаблицы.ОсновноеСредство;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(МассивОС) Тогда
		Возврат;
	КонецЕсли; 
		
	Если Не НеИзменяемыеПараметры Тогда
		              		
		// Проверим ОС.
		Отказ = Ложь;
		ДокОбъект.ПроверитьОСПриВыборе(МассивОС, Отказ);
	                       	
		Если Отказ Тогда
			
			Если Не ЭтоМассив Тогда
				ИмяСправочникаОС = бит_ОбщегоНазначения.ПолучитьИмяСправочникаОсновныеСредства();
				СтрокаТаблицы.ОсновноеСредство = Справочники[ИмяСправочникаОС].ПустаяСсылка();
			КонецЕсли;			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;

	Если МожноПерезаполнятьДанныеПоОС Тогда
		// Заполним данные по основным средствам.
		ДокОбъект.ЗаполнитьДанныеПоОсновнымСредствам(МассивОС, ?(ЭтоМассив, Неопределено, СтрокаТаблицы), НеИзменяемыеПараметры);
	КонецЕсли;
	
КонецПроцедуры // ПолучитьПараметрыОССервер()

Процедура ВыполнитьВсеРасчетыДляСтрокиОС(СтрокаОС) Экспорт 

	СтрокаОС.ОстСрокИспользования   = СтрокаОС.СрокПолезногоИспользования 
									  - СтрокаОС.ФактСрокИспользования;	
	
	СтрокаОС.ОстОбъемПродукцииРабот = СтрокаОС.ОбъемПродукцииРабот 
									  - СтрокаОС.ФактОбъемПродукцииРабот;

	СтрокаОС.ОстСтоимость = СтрокаОС.Стоимость 
							+ СтрокаОС.СуммаМодернизации 
							- СтрокаОС.СуммаФактическогоОбесценения 
							- СтрокаОС.Амортизация;
								
КонецПроцедуры // ВыполнитьВсеРасчетыДляСтрокиОС()

Процедура ВыполнитьПодборСчетов(НоваяСтрока, СтрокаТаблицы, Объект, фКоличествоСубконтоМУ) Экспорт 
	
	// Переменная, хранящее значение количества субконто БУ.
	Перем КоличествоСубконтоБУ;
	
	Если Не ЗначениеЗаполнено(СтрокаТаблицы.СчетКт) Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоСубконтоБУ = 3;
	СтруктураПараметров  = бит_му_ОбщегоНазначения.ПодготовитьСтруктуруПараметровДляПодбораСчетовМУ(Объект.Организация, Объект.Дата);

	НаборИсточник = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
	                		
	// Заполнение набора записей источник по строке таблицы значений.
	ЗаписьИсточник = НаборИсточник.Добавить();
	// ЗаписьИсточник.СчетДт = СтрокаТаблицы.СчетДт;
	ЗаписьИсточник.СчетКт = СтрокаТаблицы.СчетКт;
	
	Для i = 1 По 3 Цикл
		
		//бит_му_ОбщегоНазначения.УстановитьСубконто(ЗаписьИсточник.СчетКт, ЗаписьИсточник.СубконтоКт, i, СтрокаТаблицы["СубконтоКт" + i]);
		бит_му_ОбщегоНазначения.УстановитьСубконто(ЗаписьИсточник.СчетКт, ЗаписьИсточник.СубконтоКт, i, СтрокаТаблицы.ОбъектСтроительства);
		
	КонецЦикла; 
	
	НаборПриемник = РегистрыБухгалтерии.бит_Дополнительный_2.СоздатьНаборЗаписей();
	
	Протокол = "";
	
	// Выполнение подбора счетов по правилам трансляции.
	бит_МеханизмТрансляции.ВыполнитьТрансляциюДвижений(Объект
													, НаборИсточник
													, НаборПриемник
													, СтруктураПараметров
													, Протокол);
	
	Если НаборПриемник.Количество() > 0 Тогда
		
		// Запись результата подбора счетов в строку табличной части.
		ЗаписьПриемник = НаборПриемник[0];
		
		Если ЗначениеЗаполнено(ЗаписьПриемник.СчетКт) Тогда
			
			НоваяСтрока.СчетНезавершенногоСтроительства = ЗаписьПриемник.СчетКт;
			Для i = 1 По фКоличествоСубконтоМУ Цикл				
				НоваяСтрока["Субконто" + i] = бит_МеханизмТрансляции.ЗначениеСубконто(ЗаписьПриемник, "Кт", i);				
			КонецЦикла; 
			
			НастройкиСубконто = бит_БухгалтерияСервер.ПолучитьНастройкиСубконто(НоваяСтрока.СчетНезавершенногоСтроительства, фКоличествоСубконтоМУ);									  
			бит_БухгалтерияКлиентСервер.ПривестиЗначенияСубконто(НоваяСтрока, НастройкиСубконто, "Субконто");

		КонецЕсли; 
		
	КонецЕсли; // Трансляция выполнена

КонецПроцедуры // ВыполнитьПодборСчетов()

#КонецОбласти

#КонецЕсли
