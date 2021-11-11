﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СохраненнаяНастройка Экспорт; // Текущий вариант отчета. 
	
Перем ИмяРегистраБухгалтерии Экспорт; // Хранит имя регистра бухгалтерии.

Перем МетаданныеПланСчетов Экспорт; // Хранит метаданные плана счетов регистра бухгалтерии.

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Настройки

// Процедура выполняет сохранение настроек отчета.
// 
Процедура СохранитьНастройку() Экспорт

    ИсключаемыеРеквизиты = Новый Структура;
    ИсключаемыеРеквизиты.Вставить("ПоВалюте"); 
    ИсключаемыеРеквизиты.Вставить("Валюта");
    ИсключаемыеРеквизиты.Вставить("ПостроительОтчета");
    
    // Сформируем структуру настроек для сохранения.
    СтруктураНастроек = бит_БухгалтерскиеОтчетыСервер.ПолучитьСтруктуруПараметровДляСохранения(ЭтотОбъект, ИсключаемыеРеквизиты);
	бит_БухгалтерскиеОтчетыСервер.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
    	
КонецПроцедуры // СохранитьНастройку()

// Процедура заполняет параметры отчета по элементу справочника из переменной СохраненнаяНастройка.
// 
Процедура ПрименитьНастройку() Экспорт
	
	// Применим настройки отчета.
	бит_БухгалтерскиеОтчетыСервер.ПрименитьСохраненнуюНастройку(ЭтотОбъект, Истина, Истина, Истина);
	    
КонецПроцедуры // ПрименитьНастройку()

// Процедура заполняет настройки построителя отчетов.
// 
Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	МассивСубконто = Новый Массив;
    
    ТекстПолейРесурсов = "";
    ТекстИтогиРесурсов = "";
    МассивПоказателей  = СформироватьМассивПоказателей();
    
    Для Каждого ТекПоказатель Из МассивПоказателей Цикл
        
        ТекстПолейРесурсов = ТекстПолейРесурсов + ", ОстаткиИОбороты." + ТекПоказатель + "ОборотКт"
                             + " КАК " + ТекПоказатель + "ОборотКт";
        
        ТекстИтогиРесурсов = ТекстИтогиРесурсов + ", СУММА(" + ТекПоказатель + "ОборотКт)";
                             
    КонецЦикла;
    
    ТекстПолейРесурсов = Сред(ТекстПолейРесурсов, 2);
    ТекстИтогиРесурсов = Сред(ТекстИтогиРесурсов, 2);
    
	Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	" + ?(ПустаяСтрока(ТекстПолейРесурсов), " """" Как Поле", ТекстПолейРесурсов);
    
	ТекстПоля    = "";
	// Изменение кода. Начало. 12.05.2014{{
	ТекстОтбор   = "Валюта, ЦФО.*, Сценарий.*, Организация.*";
	// Изменение кода. Конец. 12.05.2014}}
	ТекстИтоги   = "";
	ТекстПорядок = "";
	
	бит_БухгалтерскиеОтчетыСервер.УдалитьПустыеСубконтоИзТабличнойЧасти(Субконто);
	
	МассивВидыСубконто = Новый Массив;

	Для каждого СтрСубконто Из Субконто Цикл
		
		Если Не ЗначениеЗаполнено(СтрСубконто.ВидСубконто) Тогда
			Продолжить;
		КонецЕсли;
		
		МассивСубконто.Добавить(СтрСубконто.ВидСубконто);
		МассивВидыСубконто.Добавить(СтрСубконто.ВидСубконто);
		
		ТекстПоля    = ТекстПоля    + ", ОстаткиИОбороты.Субконто" + СтрСубконто.НомерСтроки + " КАК Субконто" + СтрСубконто.НомерСтроки;
		ТекстОтбор   = ТекстОтбор   + ", Субконто" + СтрСубконто.НомерСтроки + ".* ";
		ТекстИтоги   = ТекстИтоги   + ", Субконто" + СтрСубконто.НомерСтроки;
		ТекстПорядок = ТекстПорядок + ", ОстаткиИОбороты.Субконто" + СтрСубконто.НомерСтроки + ".*";
	
	КонецЦикла;
    
	Если Не ПустаяСтрока(ТекстПоля) Тогда
		Текст = Текст +	"
		|{ВЫБРАТЬ
		|" + Сред(ТекстПоля
		, 2) 
		+ "}";
	КонецЕсли;
	
	ТекстОтбор = "{"+ТекстОтбор+"}";
	
	Текст = Текст + "
	|ИЗ
	|	РегистрБухгалтерии." + ИмяРегистраБухгалтерии + ".ОстаткиИОбороты(, , МЕСЯЦ, , {Счет} , &МассивСубконто, " + ТекстОтбор + ") КАК ОстаткиИОбороты
	|";
	
	Если Не ПустаяСтрока(ТекстПорядок) Тогда
		Текст = Текст + "
		|{УПОРЯДОЧИТЬ ПО 
		|" + Сред(ТекстПорядок 
		, 2) + "}";
	КонецЕсли;
	
	Текст = Текст + "
	|ИТОГИ " + ТекстИтогиРесурсов + " ПО ОБЩИЕ";
	
	Если Не ПустаяСтрока(ТекстПоля) Тогда
		Текст = Текст + "
		|{ИТОГИ ПО
		|" + Сред(ТекстПоля 
		, 2) + "}";
	КонецЕсли;
	
	ПостроительОтчета.Параметры.Вставить("МассивСубконто", МассивСубконто);
	
	ПостроительОтчета.Текст = Текст;
	
	бит_БухгалтерскиеОтчетыСервер.УстановитьТипыОтборовПостроителяПоСубконто(ПостроительОтчета, МассивСубконто);
    
    // Определим признаки учета субконто, которые могут быть использованы.
    СтруктураУчета = бит_БухгалтерскиеОтчетыСервер.ОпределитьПризнакиУчетаСубконтоРегистраБухгалтерии(ИмяРегистраБухгалтерии, МассивВидыСубконто);
    ПоВалютам    = СтруктураУчета.ЕстьВалюта;
	ПоКоличеству = СтруктураУчета.ЕстьКоличество;
    
КонецПроцедуры // ЗаполнитьНачальныеНастройки()

// Перезаполнение настроек построителя отчетов с сохранением пользовательских настроек.
// 
Процедура ПерезаполнитьНачальныеНастройки() Экспорт
	
	Настройки = ПостроительОтчета.ПолучитьНастройки();
	
	ЗаполнитьНачальныеНастройки();
	
	ПостроительОтчета.УстановитьНастройки(Настройки);
    
КонецПроцедуры // ПерезаполнитьНачальныеНастройки()
 
#КонецОбласти

#Область ЗаголовокОтчета

// Функция формирует заголовок отчета (синоним).
// 
// Возвращаемое значение:
//  Строка - заголовок отчета.
// 
Функция ЗаголовокОтчета() Экспорт
	
	ПредставлениеРегистра = Нстр("ru = 'бюджетирование'");
	
	ТекстЗаголовка = Нстр("ru = 'Карточка субконто (%1%)'");
	ТекстЗаголовка = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстЗаголовка, ПредставлениеРегистра);

    Возврат ТекстЗаголовка;
       
КонецФункции // ЗаголовокОтчета()

// Функция выводит шапку отчета.
// 
// Возвращаемое значение:
// 	ТабличныйДокумент - заголовок отчета.
// 
Функция СформироватьЗаголовок() Экспорт

    ОписаниеПериода = бит_БухгалтерскиеОтчетыСервер.СформироватьСтрокуВыводаПараметровПоДатам(Период.ДатаНачала, Период.ДатаОкончания);

	Макет = ПолучитьМакет("Макет");
	ЗаголовокОтчета = Макет.ПолучитьОбласть("Заголовок");

	ЗаголовокОтчета.Параметры.ОписаниеПериода  = ОписаниеПериода;
	ЗаголовокОтчета.Параметры.Заголовок        = ЗаголовокОтчета();

	// Вывод списка фильтров:
	СтрФильтры     = "";
	СтрДетализация = "";

	Для каждого стр Из Субконто Цикл
		СтрДетализация = СтрДетализация + "; " + Строка(стр.ВидСубконто);
	КонецЦикла;
	
	СтрФильтры = бит_БухгалтерскиеОтчетыСервер.СформироватьСтрокуОтборов(ПостроительОтчета.Отбор);
	
	СтрДетализация = Сред(СтрДетализация, 3);
	Если Не ПустаяСтрока(СтрДетализация) Тогда
		ЗаголовокОтчета.Параметры.Детализация = СтрДетализация;
	КонецЕсли;

    ТекстСписокПоказателей = Нстр("ru = 'Выводимые данные: '");
    
    Если ВыводитьСуммуРегл Тогда 
        ТекстСписокПоказателей = ТекстСписокПоказателей + Нстр("ru = 'сумма (регл.)'");
    КонецЕсли;
    Если ВыводитьСуммуУпр Тогда 
        ТекстСписокПоказателей = ТекстСписокПоказателей + ?(Найти(ТекстСписокПоказателей, "сумма") = 0, "", ", ") + Нстр("ru = 'сумма (упр.)'");
    КонецЕсли;
    Если ВыводитьСуммуСценарий И бит_БухгалтерскиеОтчетыСервер.ПроверитьИспользованиеСценария(ПостроительОтчета) Тогда 
        ТекстСписокПоказателей = ТекстСписокПоказателей + ?(Найти(ТекстСписокПоказателей, "сумма") = 0, "", ", ") + Нстр("ru = 'сумма (сценарий)'");
    КонецЕсли;
    
    ТекстСписокПоказателей = ТекстСписокПоказателей + ?(Найти(ТекстСписокПоказателей, "сумма") = 0, "", ", ") + Нстр("ru = 'количество, валютная сумма'");
    
    ЗаголовокОтчета.Параметры.ТекстПроСписокПоказателей = ТекстСписокПоказателей;
    
	ОбластьОтбор = Макет.ПолучитьОбласть("СтрокаОтбор");

	Если Не ПустаяСтрока(СтрФильтры) Тогда
		ОбластьОтбор.Параметры.ТекстПроОтбор = Нстр("ru = 'Отбор: '") + СтрФильтры;
		ЗаголовокОтчета.Вывести(ОбластьОтбор);
	КонецЕсли;

	Возврат(ЗаголовокОтчета);

КонецФункции // СформироватьЗаголовок()

#КонецОбласти

#Область ФормированиеОтчета

// Процедура выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
// 
// Параметры:
//  ДокументРезультат   - ТабличныйДокумент - Табличный документ, формируемый отчетом.
//  ПоказыватьЗаголовок - Булево (По умолчанию = Истина) - признак отображения заголовка.
//  ВысотаЗаголовка     - Число (По умолчанию = 0) - высота заголовка.
// 
// Возвращаемое значение:
//  Булево - отчет сформирован.
// 
Функция СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок = Истина, ВысотаЗаголовка = 0) Экспорт
	
	// Очистка табличного поля
	ДокументРезультат.Очистить();	
	
	Если Не ПараметрыОтчетаКорректны() Тогда
		
		ОтчетСформирован = Ложь;
		
	Иначе
		
		ОтчетСформирован = Истина;
	   	
	
		// Вывод заголовка отчета
		бит_БухгалтерскиеОтчетыСервер.СформироватьИВывестиЗаголовокОтчета(ЭтотОбъект, ДокументРезультат, ВысотаЗаголовка, ПоказыватьЗаголовок);
 	    
	    МассивПоказателей = СформироватьМассивПоказателей();
	    
	    Запрос = Новый Запрос;
		ПолучитьТекстЗапроса(Запрос, МассивПоказателей);
		
		УстановитьПараметрыЗапроса(Запрос);
		
		Результат = Запрос.Выполнить();

		ВыборкаОбщие = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Общие");
		ВыборкаОбщие.Следующий();
		
		ВыборкаПоПериодам = ВыборкаОбщие.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "НачПериода");
		ВыборкаПоПериодам.Следующий();
		
		ВыборкаДетальная = ВыборкаПоПериодам.Выбрать(ОбходРезультатаЗапроса.Прямой);
		ВыборкаДетальная.Следующий();
		
		Макет = ПолучитьМакет("Макет");
		ОблШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ОблСальдо       = Макет.ПолучитьОбласть("Сальдо");
		
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("ОбластьШапкаТаблицы"		   , ОблШапкаТаблицы);
		СтруктураПараметров.Вставить("ОбластьЗаголовокПроводки"	   , Макет.ПолучитьОбласть("ЗаголовокПроводки"));
		СтруктураПараметров.Вставить("ОбластьОбороты"			   , Макет.ПолучитьОбласть("Обороты"));
		СтруктураПараметров.Вставить("ОбластьСтрокаСубконто"	   , Макет.ПолучитьОбласть("СтрокаСубконто"));
		СтруктураПараметров.Вставить("ОбластьКоличествоПроводки"   , Макет.ПолучитьОбласть("КоличествоПроводки"));
		СтруктураПараметров.Вставить("ОбластьВалютнаяСуммаПроводки", Макет.ПолучитьОбласть("ВалютнаяСуммаПроводки"));
	    СтруктураПараметров.Вставить("МассивРесурсов"			   , МассивПоказателей);
	    
		ДокументРезультат.Вывести(ОблШапкаТаблицы, 1);
		
		ОблСальдо.Параметры.ОписательСальдо = "Сальдо на " + формат(Период.ДатаНачала, "ДФ=dd.MM.yyyy");
	    
	    СоотвИменПараметров = Новый Соответствие;
	    СоотвИменПараметров.Вставить("НачальныйОстатокДт", "СуммаСальдоДт");
	    СоотвИменПараметров.Вставить("НачальныйОстатокКт", "СуммаСальдоКт");
	    
	    // Заполним параметры области.
	    бит_БухгалтерскиеОтчетыСервер.ЗаполнитьЗначениеПараметровОбластиПоМассивуРесурсов(ОблСальдо, ВыборкаДетальная, МассивПоказателей, 
	                                                                                "НачальныйОстатокДт, НачальныйОстатокКт",,
	                                                                                СоотвИменПараметров);
	    
		ДокументРезультат.Вывести(ОблСальдо, 1);
		
		// Вывод основной части отчета
		ДокументРезультат.НачатьАвтогруппировкуСтрок();
		
		Если Не ЗначениеЗаполнено(Периодичность) Тогда
			// Без разбивки по периодам
			ВывестиПроводки(ДокументРезультат, ВыборкаОбщие, СтруктураПараметров);
		Иначе
			// С разбивкой по периодам
			ФорматПериода = бит_БухгалтерскиеОтчетыСервер.ПолучитьСтрокуФорматаПериода(Периодичность);
			
			ВыборкаПоПериодам = ВыборкаОбщие.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "НачПериода");
			
			Пока ВыборкаПоПериодам.Следующий() Цикл
				
				ВывестиПодИтог(ДокументРезультат, ВыборкаПоПериодам, СтруктураПараметров, Формат(ВыборкаПоПериодам.НачПериода, ФорматПериода));
				
				ВывестиПроводки(ДокументРезультат, ВыборкаПоПериодам, СтруктураПараметров);
				
			КонецЦикла;
			
		КонецЕсли;
		
		ВывестиПодИтог(ДокументРезультат, ВыборкаОбщие, СтруктураПараметров, "Итого за период");
		
		ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
		
		// Вывод конечного сальдо
		ОблСальдоПараметры = ОблСальдо.Параметры;
		ОблСальдоПараметры.ОписательСальдо = "Сальдо на " + формат(Период.ДатаОкончания, "ДФ=dd.MM.yyyy");
		
		ВыборкаПоПериодам.Сбросить();
		
		Пока ВыборкаПоПериодам.Следующий() Цикл
			
			ВыборкаДетальная = ВыборкаПоПериодам.Выбрать(ОбходРезультатаЗапроса.Прямой);
			
	        Пока ВыборкаДетальная.Следующий() Цикл
	            
	            СоотвИменПараметров = Новый Соответствие;
	            СоотвИменПараметров.Вставить("КонечныйОстатокДт", "СуммаСальдоДт");
	            СоотвИменПараметров.Вставить("КонечныйОстатокКт", "СуммаСальдоКт");
	            
	            // Заполнение параметров области.
	            бит_БухгалтерскиеОтчетыСервер.ЗаполнитьЗначениеПараметровОбластиПоМассивуРесурсов(ОблСальдо, ВыборкаДетальная, МассивПоказателей, 
	                                                                                        "КонечныйОстатокДт, КонечныйОстатокКт",,
	                                                                                        СоотвИменПараметров);
			
			КонецЦикла;
																						
		КонецЦикла;
		
		ДокументРезультат.Вывести(ОблСальдо, 1);
		
		// Фиксация заголовка отчета
		ДокументРезультат.ФиксацияСверху = ВысотаЗаголовка + 3;
		
		// Печать шапки отчета на каждой странице
		ДокументРезультат.ПовторятьПриПечатиСтроки = ДокументРезультат.Область(ВысотаЗаголовка + 1, ,ВысотаЗаголовка + 3);

		// Отмена печати первой колонки
		ДокументРезультат.ОбластьПечати = ДокументРезультат.Область(1, 2, ДокументРезультат.ВысотаТаблицы, ДокументРезультат.ШиринаТаблицы);
		
		// Присвоение имени для сохранения параметров печати табличного документа.
		ДокументРезультат.КлючПараметровПечати = "КарточкаСубконто" + ИмяРегистраБухгалтерии;

		бит_БухгалтерскиеОтчетыСервер.УстановитьКолонтитулыПоУмолчанию(ДокументРезультат, ЗаголовокОтчета(), Строка(бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")));
		
	КонецЕсли;
	
	Возврат ОтчетСформирован;
	
КонецФункции // СформироватьОтчет()

// Функция возвращает массив показателей (ресурсов регистра) для отчета.
// 
// Возвращаемое значение:
//  Массив - массив показателей.
//
Функция СформироватьМассивПоказателей() Экспорт
	
	МассивПоказателей = Новый Массив;
    
    Если ВыводитьСуммуРегл Тогда 
        МассивПоказателей.Добавить("СуммаРегл");
    КонецЕсли;
    
    Если ВыводитьСуммуУпр Тогда 
        МассивПоказателей.Добавить("СуммаУпр");
    КонецЕсли;  
    
    Если ВыводитьСуммуСценарий Тогда 
        МассивПоказателей.Добавить("СуммаСценарий");
    КонецЕсли;
    
	Возврат МассивПоказателей;
		
КонецФункции // СформироватьМассивПоказателей()

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проверки

// Проверка корректности настроек отчета
// 
// Параметры
//  Нет
// 
// Возвращаемое значение:
//   Булево
// 
Функция ПараметрыОтчетаКорректны()

	РезультатПроверки = 
		бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Период.ДатаНачала, Период.ДатаОкончания)
		И бит_БухгалтерскиеОтчетыСервер.ПроверитьКорректностьСубконто(Субконто)
		И бит_БухгалтерскиеОтчетыСервер.ПроверитьНаличиеВыбранногоПоказателя(ЭтотОбъект, Истина);
		
	Возврат РезультатПроверки;
	
КонецФункции // ПараметрыОтчетаКорректны()

#КонецОбласти

#Область ФормированиеОтчета

// Процедура Формирования текста запроса на основании настроек пользователя.
// 
// Параметры
//  Запрос 			  - Запрос.
//  МассивПоказателей - Массив.
// 
// Возвращаемое значение:
//   Строка - Текст запроса.
// 
Процедура ПолучитьТекстЗапроса(Запрос, МассивПоказателей)

	СтрокаСубконтоДт = "";
	СтрокаСубконтоКт = "";
	
	Для н=1 По МетаданныеПланСчетов.МаксКоличествоСубконто Цикл
						
		СтрокаСубконтоДт = СтрокаСубконтоДт + СтрЗаменить("
		|	ПРЕДСТАВЛЕНИЕ(ДвиженияССубконто.СубконтоДт{к}) КАК СубконтоДт{к}Представление,",
		"{к}",Строка(н));
	
		СтрокаСубконтоКт = СтрокаСубконтоКт + СтрЗаменить("
		|	ПРЕДСТАВЛЕНИЕ(ДвиженияССубконто.СубконтоКт{к}) КАК СубконтоКт{к}Представление,",
		"{к}",Строка(н));
	
	КонецЦикла;
    
    ТекстПолейРесурсов = "";
    ТекстИтогиРесурсов = "";
    
    Для Каждого ТекПоказатель Из МассивПоказателей Цикл
        
        ТекстПолейРесурсов = ТекстПолейРесурсов + "
                             |	 ОстаткиИОбороты." + ТекПоказатель + "НачальныйОстатокДт,
                             |	 ОстаткиИОбороты." + ТекПоказатель + "НачальныйОстатокКт,
                             |	 ОстаткиИОбороты." + ТекПоказатель + "КонечныйОстатокДт,
                             |	 ОстаткиИОбороты." + ТекПоказатель + "КонечныйОстатокКт,
                             |	 ОстаткиИОбороты." + ТекПоказатель + "ОборотДт КАК " + ТекПоказатель + "ОборотДт,
                             |	 ОстаткиИОбороты." + ТекПоказатель + "ОборотКт КАК " + ТекПоказатель + "ОборотКт,";
        
        ТекстИтогиРесурсов = ТекстИтогиРесурсов + "
                             |	 СУММА(" + ТекПоказатель + "ОборотДт),
                        	 |	 СУММА(" + ТекПоказатель + "ОборотКт),
                        	 |	 СУММА(" + ТекПоказатель + "НачальныйОстатокДт),
                        	 |	 СУММА(" + ТекПоказатель + "НачальныйОстатокКт),
                        	 |	 СУММА(" + ТекПоказатель + "КонечныйОстатокДт),
                        	 |	 СУММА(" + ТекПоказатель + "КонечныйОстатокКт),";
    КонецЦикла;
    
    ТекстИтогиРесурсов = Сред(ТекстИтогиРесурсов, 1, СтрДлина(ТекстИтогиРесурсов) - 1);
    
	Сч = 0;
	ТекстОтборСчетов = "";
	ТекстУсловиеОстатковИОборотов = "";
    
	Для каждого Элемент Из ПостроительОтчета.Отбор Цикл
		
		Если НЕ Элемент.Использование ИЛИ ПустаяСтрока(Элемент.ПутьКДанным) Тогда
			Продолжить;
		КонецЕсли;
		
		ОграничениеДляОтбора = бит_БухгалтерскиеОтчетыСервер.ПолучитьСтрокуОтбора(Элемент.ВидСравнения
																, "&ПараметрОтбора" + Сч
																, Элемент.ПутьКДанным
																, "&ПараметрОтбораС" + Сч
																, "&ПараметрОтбораПо" + Сч
																, Элемент.Значение
																, Элемент.ЗначениеС
																, Элемент.ЗначениеПо);
		
		Если Врег(Лев(Элемент.ПутьКДанным, 4)) = "СЧЕТ" Тогда
			ТекстОтборСчетов = ТекстОтборСчетов + " И " + ОграничениеДляОтбора;			
		Иначе
			Если Не ПустаяСтрока(ТекстУсловиеОстатковИОборотов) Тогда
				ТекстУсловиеОстатковИОборотов = ТекстУсловиеОстатковИОборотов + " И ";	
			КонецЕсли;
			
			ТекстУсловиеОстатковИОборотов = ТекстУсловиеОстатковИОборотов + ОграничениеДляОтбора;
		КонецЕсли;
		
		Сч = Сч + 1;
	
	КонецЦикла;
	
	// Изменение кода. Начало. 12.05.2014{{
    ТекстДопОтбор    = "{ЦФО.*, Сценарий.*, Организация.*}";
	// Изменение кода. Конец. 12.05.2014}}
	ТекстОтборСчетов = Сред(ТекстОтборСчетов, 3);
		
	ОграничениеПоТипамСубконто = бит_БухгалтерскиеОтчетыСервер.СформироватьОграниченияПоТипуСубконто(Запрос, Субконто.ВыгрузитьКолонку("ВидСубконто"), 
		ИмяРегистраБухгалтерии, "ДвиженияССубконто");
	
	Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НАЧАЛОПЕРИОДА(ДвиженияССубконто.Период, " + ?(Периодичность = "" ИЛИ Периодичность = "РЕГИСТРАТОР", "ДЕНЬ", Периодичность) + ") КАК НачПериода,
	|	ДвиженияССубконто.Период 					 КАК Период,
	|	ДвиженияССубконто.Регистратор 				 КАК Регистратор,
	|	ДвиженияССубконто.Содержание 				 КАК Содержание,
	|	ПРЕДСТАВЛЕНИЕ(ДвиженияССубконто.Регистратор) КАК РегистраторПредставление,
	|	ДвиженияССубконто.НомерСтроки 				 КАК НомерСтроки,
	|	ДвиженияССубконто.СчетДт.Вид 				 КАК ВидСчетаДт,
	|	ДвиженияССубконто.СчетКт.Вид 				 КАК ВидСчетаКт,
	|	ДвиженияССубконто.СчетДт.Валютный 			 КАК СчетВалютныйДт,
	|	ДвиженияССубконто.СчетКт.Валютный 			 КАК СчетВалютныйКт,
	|	ДвиженияССубконто.СчетДт.Количественный 	 КАК СчетКоличественныйДт,
	|	ДвиженияССубконто.СчетКт.Количественный 	 КАК СчетКоличественныйКт,
	|	ДвиженияССубконто.СчетДт.Представление 		 КАК СчетДтПредставление,
	|	ДвиженияССубконто.СчетКт.Представление 		 КАК СчетКтПредставление,
	|	ДвиженияССубконто.КоличествоДт,
	|	ДвиженияССубконто.КоличествоКт,
	|	" + СтрокаСубконтоДт
	   	  + СтрокаСубконтоКт + "
	|	ДвиженияССубконто.ВалютаДт.Представление КАК ВалютаДт,
	|	ДвиженияССубконто.ВалютаКт.Представление КАК ВалютаКт,
	|	ДвиженияССубконто.ВалютнаяСуммаДт,
	|	ДвиженияССубконто.ВалютнаяСуммаКт,
	|	ДвиженияССубконто.Регистратор.Дата КАК РегистраторДата,
	|	" + ТекстПолейРесурсов + "
	|	ОстаткиИОбороты.КоличествоОборотДт,
	|	ОстаткиИОбороты.КоличествоОборотКт,
	|	ОстаткиИОбороты.ВалютнаяСуммаОборотДт,
	|	ОстаткиИОбороты.ВалютнаяСуммаОборотКт
	|ИЗ
	|		РегистрБухгалтерии." + ИмяРегистраБухгалтерии + ".ДвиженияССубконто(&ДатаНач, &ДатаКон, " + ТекстУсловиеОстатковИОборотов + ТекстДопОтбор + ") КАК ДвиженияССубконто
	|		
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрБухгалтерии." + ИмяРегистраБухгалтерии + ".ОстаткиИОбороты(&ДатаНач, &ДатаКон, Запись, , " + ТекстОтборСчетов + ", &МассивСубконто, " + ТекстУсловиеОстатковИОборотов + ТекстДопОтбор + ") КАК ОстаткиИОбороты
	|		ПО ДвиженияССубконто.Регистратор = ОстаткиИОбороты.Регистратор
	|			И ДвиженияССубконто.НомерСтроки = ОстаткиИОбороты.НомерСтроки
	|ГДЕ
	|	" + ОграничениеПоТипамСубконто + "
	|
	|УПОРЯДОЧИТЬ ПО
	|	НачПериода,
	|	Период,
	|	РегистраторДата,
	|	Регистратор,
	|	НомерСтроки
	|ИТОГИ
	|	" + ТекстИтогиРесурсов + "
	|ПО
	|	Общие,
	|	НачПериода " + ?(ВсеПериоды И ЗначениеЗаполнено(Периодичность), "ПЕРИОДАМИ(" + Периодичность + ",,)", "");
	
	Запрос.Текст = Текст;	

КонецПроцедуры // ПолучитьТекстЗапроса()

// Установка параметров запроса
// 
// Параметры
//  Запрос - Запрос.
// 
Процедура УстановитьПараметрыЗапроса(Запрос)

	Запрос.УстановитьПараметр("ДатаНач", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаКон", ?(Период.ДатаОкончания = '00010101', Период.ДатаОкончания, Новый Граница(КонецДня(Период.ДатаОкончания), ВидГраницы.Включая)));
	
	Запрос.УстановитьПараметр("Дебет", ВидДвиженияБухгалтерии.Дебет);

    Для каждого СтрСубконто Из Субконто Цикл
        
		сн = Строка(СтрСубконто.НомерСтроки);
		Запрос.УстановитьПараметр("Вид" + сн, СтрСубконто.ВидСубконто);
        
	КонецЦикла;
	
	Сч = 0;
	Для каждого Элемент Из ПостроительОтчета.Отбор Цикл
		
		Если НЕ Элемент.Использование ИЛИ ПустаяСтрока(Элемент.ПутьКДанным) Тогда
			Продолжить;
		КонецЕсли;
		
		Запрос.УстановитьПараметр("ПараметрОтбора" + Сч  , Элемент.Значение);
		Запрос.УстановитьПараметр("ПараметрОтбораС" + Сч , Элемент.ЗначениеС);
		Запрос.УстановитьПараметр("ПараметрОтбораПо" + Сч, Элемент.ЗначениеПо);
		
		Сч= Сч + 1;
	
	КонецЦикла;

	Запрос.УстановитьПараметр("МассивСубконто", Субконто.ВыгрузитьКолонку("ВидСубконто"));
	
КонецПроцедуры // УстановитьПараметрыЗапроса()

// Процедура выводит секции субконто в отчет.
// 
// Параметры
//  ДокументРезультат   - ТабличныйДокумент.
//  ВыборкаПроводок     - ВыборкаИзРезультатаЗапроса.
//  СтруктураПараметров - Структура.
//  Расшифровка         - Структура.
// 
Процедура ВывестиСубконто(ДокументРезультат, ВыборкаПроводок, СтруктураПараметров, Расшифровка)

    НачалоСтроки = ДокументРезультат.ВысотаТаблицы;
    
	ОблСубконто = СтруктураПараметров.ОбластьСтрокаСубконто;
	
	Для н = 1 По МетаданныеПланСчетов.МаксКоличествоСубконто Цикл
		Содержание = ВыборкаПроводок[СтрЗаменить("СубконтоДт{н}Представление", "{н}", Строка(н))];
		Если ЗначениеЗаполнено(Содержание) Тогда
			ОблСубконто.Параметры.Содержание  = Содержание;
			ОблСубконто.Параметры.Расшифровка = Расшифровка;
			ДокументРезультат.Вывести(ОблСубконто, ВыборкаПроводок.Уровень());
		КонецЕсли;
	КонецЦикла;
	
	Для н = 1 По МетаданныеПланСчетов.МаксКоличествоСубконто Цикл
		Содержание = ВыборкаПроводок[СтрЗаменить("СубконтоКт{н}Представление", "{н}", Строка(н))];
		Если ЗначениеЗаполнено(Содержание) Тогда
			ОблСубконто.Параметры.Содержание  = Содержание;
			ОблСубконто.Параметры.Расшифровка = Расшифровка;
			ДокументРезультат.Вывести(ОблСубконто, ВыборкаПроводок.Уровень());
		КонецЕсли;
	КонецЦикла;
    
    КонецСтроки = ДокументРезультат.ВысотаТаблицы;
    
    // Запомним текст строк с аналитикой.
    ТекстАналитики = "";
    
    Для Ном = НачалоСтроки По КонецСтроки Цикл
        
        Область      = ДокументРезультат.Область(Ном, 4, Ном, 4);
        ТекстОбласти = Область.Текст;
        
        Если Не ПустаяСтрока(ТекстОбласти) Тогда
            ТекстАналитики = ТекстАналитики + ?(ПустаяСтрока(ТекстАналитики), "", Символы.ПС)
                             + ТекстОбласти;
        КонецЕсли;
        
    КонецЦикла;
    
    Область = ДокументРезультат.Область(НачалоСтроки, 4, КонецСтроки, 4);
    Область.Объединить();
    Область.Текст       = ТекстАналитики;
    Область.Расшифровка = Расшифровка;
    Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.Строка;
    Область.РазмещениеТекста         = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
    
КонецПроцедуры // ВывестиСубконто()

// Вывод секции количества в отчет.
// 
// Параметры
//  ДокументРезультат   - ТабличныйДокумент.
//  ВыборкаПроводок     - ВыборкаИзРезультатаЗапроса.
//  СтруктураПараметров - Структура.
//  Расшифровка         - Структура.
// 
Процедура ВывестиКоличество(ДокументРезультат, ВыборкаПроводок, СтруктураПараметров, Расшифровка)

	ОблКоличество = СтруктураПараметров.ОбластьКоличествоПроводки;
	
	ОблКоличество.Параметры.Заполнить(ВыборкаПроводок);
	ОблКоличество.Параметры.Расшифровка = Расшифровка;
	
	ДокументРезультат.Вывести(ОблКоличество, ВыборкаПроводок.Уровень());
	
КонецПроцедуры // ВывестиКоличество()

// Вывод секции валют в отчет.
// 
// Параметры
//  ДокументРезультат   - ТабличныйДокумент.
//  ВыборкаПроводок     - ВыборкаИзРезультатаЗапроса.
//  СтруктураПараметров - Структура.
//  Расшифровка         - Структура.
// 
Процедура ВывестиВалюты(ДокументРезультат, ВыборкаПроводок, СтруктураПараметров, Расшифровка)

	ОблВалюты = СтруктураПараметров.ОбластьВалютнаяСуммаПроводки;
	
	ОблВалюты.Параметры.Заполнить(ВыборкаПроводок);
	ОблВалюты.Параметры.Расшифровка = Расшифровка;
	
	ДокументРезультат.Вывести(ОблВалюты, ВыборкаПроводок.Уровень());
	
КонецПроцедуры // ВывестиВалюты()

// Процедура выводит данные по проводке.
// 
// Параметры
//  ДокументРезультат     - ТабличныйДокумент.
//  ВыборкаВерхнегоУровня - ВыборкаИзРезультатаЗапроса.
//  СтруктураПараметров   - Структура.
// 
Процедура ВывестиПроводки(ДокументРезультат, ВыборкаВерхнегоУровня, СтруктураПараметров)
	
	ОблЗаголовокПроводки = СтруктураПараметров.ОбластьЗаголовокПроводки;
	
	ВыборкаПроводок = ВыборкаВерхнегоУровня.Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока ВыборкаПроводок.Следующий() Цикл
		
		Если ВыборкаПроводок.ТипЗаписи() <> ТипЗаписиЗапроса.ДетальнаяЗапись Тогда
			Продолжить;
		КонецЕсли;
		
		Расшифровка = Новый Структура;
		Расшифровка.Вставить("Регистратор", ВыборкаПроводок.Регистратор);
		Расшифровка.Вставить("НомерСтроки", ВыборкаПроводок.НомерСтроки);
	
		ОблЗаголовокПроводки.Параметры.Заполнить(ВыборкаПроводок);
        
        // Заполним параметры области.
        бит_БухгалтерскиеОтчетыСервер.ЗаполнитьЗначениеПараметровОбластиПоМассивуРесурсов(ОблЗаголовокПроводки
																						, ВыборкаПроводок
																						, СтруктураПараметров.МассивРесурсов
																						, "ОборотДт, ОборотКт");
        
		ОблЗаголовокПроводки.Параметры.Расшифровка = Расшифровка;
        
        ТекстОстаток = "";
        ТекстФлаг    = "";
        
        Для Каждого ТекРесурс Из СтруктураПараметров.МассивРесурсов Цикл
            
            СуммаКонечныйОстатокДт = ВыборкаПроводок[ТекРесурс + "КонечныйОстатокДт"];
            СуммаКонечныйОстатокКт = ВыборкаПроводок[ТекРесурс + "КонечныйОстатокКт"];
            
            Если СуммаКонечныйОстатокДт > СуммаКонечныйОстатокКт Тогда
                
                ТекстФлаг    = ТекстФлаг    + ?(ПустаяСтрока(ТекстФлаг),    "", Символы.ПС) + "Д";
                ТекстОстаток = ТекстОстаток + ?(ПустаяСтрока(ТекстОстаток), "", Символы.ПС) 
                               + Строка(Формат(СуммаКонечныйОстатокДт - СуммаКонечныйОстатокКт, "ЧЦ=15; ЧДЦ=2"));
            Иначе

                ТекстФлаг    = ТекстФлаг    + ?(ПустаяСтрока(ТекстФлаг),    "", Символы.ПС) + "К";
                ТекстОстаток = ТекстОстаток + ?(ПустаяСтрока(ТекстОстаток), "", Символы.ПС) 
                               + Строка(Формат(СуммаКонечныйОстатокКт - СуммаКонечныйОстатокДт, "ЧЦ=15; ЧДЦ=2"));
            КонецЕсли;
            
        КонецЦикла;
        
        ОблЗаголовокПроводки.Параметры.Флаг    = ТекстФлаг;
        ОблЗаголовокПроводки.Параметры.Остаток = ТекстОстаток;
		
		ДокументРезультат.Вывести(ОблЗаголовокПроводки, ВыборкаПроводок.Уровень());
		
		ВерхСекции = ДокументРезультат.ВысотаТаблицы;
		
		ВывестиСубконто(ДокументРезультат, ВыборкаПроводок, СтруктураПараметров, Расшифровка);
		Если ВыборкаПроводок.СчетКоличественныйДт = Истина 
			ИЛИ ВыборкаПроводок.СчетКоличественныйКт = Истина Тогда
			
			ВывестиКоличество(ДокументРезультат, ВыборкаПроводок, СтруктураПараметров, Расшифровка);
			
		КонецЕсли;
		
		Если ВыборкаПроводок.СчетВалютныйДт = Истина 
			ИЛИ ВыборкаПроводок.СчетВалютныйКт = Истина Тогда
			
			ВывестиВалюты(ДокументРезультат, ВыборкаПроводок, СтруктураПараметров, Расшифровка);
			
		КонецЕсли;
		
		НизСекции = ДокументРезультат.ВысотаТаблицы;
		
		ДокументРезультат.Область(ВерхСекции,2,НизСекции,2).Объединить();
		ДокументРезультат.Область(ВерхСекции,3,НизСекции,3).Объединить();
		
	КонецЦикла;
	
КонецПроцедуры // ВывестиПроводки()

// Процедура выводит общий итог или итог по периоду.
// 
// Параметры
//  ДокументРезультат   - ТабличныйДокумент.
//  Выборка             - ВыборкаИзРезультатаЗапроса.
//  СтруктураПараметров - Структура.
//  ОписательПериода    - Строка.
// 
Процедура ВывестиПодИтог(ДокументРезультат, Выборка, СтруктураПараметров, ОписательПериода)

	ОблИтог = СтруктураПараметров.ОбластьОбороты;
	
	ОблИтог.Параметры.ОписательПериода = ОписательПериода;
    
    // Заполним параметры области.
    бит_БухгалтерскиеОтчетыСервер.ЗаполнитьЗначениеПараметровОбластиПоМассивуРесурсов(ОблИтог
																				, Выборка
																				, СтруктураПараметров.МассивРесурсов
																				, "ОборотДт, ОборотКт");
    
	ДокументРезультат.Вывести(ОблИтог, Выборка.Уровень());

КонецПроцедуры // ВывестиПодИтог()

#КонецОбласти

#КонецОбласти

#Область Инициализация

ИмяРегистраБухгалтерии = "бит_Бюджетирование";
МетаданныеПланСчетов   = Метаданные.РегистрыБухгалтерии[ИмяРегистраБухгалтерии].ПланСчетов;

СохраненнаяНастройка = Справочники.бит_СохраненныеНастройки.ПустаяСсылка();

#КонецОбласти

#КонецЕсли
