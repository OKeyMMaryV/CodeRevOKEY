#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СохраненнаяНастройка Экспорт; // Текущий вариант отчета.  

Перем ИмяРегистраБухгалтерии Экспорт; // Хранит имя регистра бухгалтерии.

Перем мСписокРегистров Экспорт; // Хранит список регистров бухгалтерии управленческого учета.

Перем мПрограммноеОткрытие Экспорт; // Хранит значение программного открытия отчета.

Перем мЕстьРесурсСуммаМУ Экспорт; // Хранит подтверждение наличия ресурса "СуммаМУ".

Перем ЕстьВалюта Экспорт; // Хранить признак наличия валюты.

Перем ЕстьКоличество Экспорт; // Хранить признак наличия количества.

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Настройки

// Процедура выполняет сохранение настроек отчета.
// 
Процедура СохранитьНастройку() Экспорт

    ИсключаемыеРеквизиты = Новый Структура;
    ИсключаемыеРеквизиты.Вставить("ПостроительОтчета");
    
    // Сформируем структуру настроек для сохранения.
    СтруктураНастроек = бит_БухгалтерскиеОтчетыСервер.ПолучитьСтруктуруПараметровДляСохранения(ЭтотОбъект, ИсключаемыеРеквизиты);
	бит_БухгалтерскиеОтчетыСервер.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
    
КонецПроцедуры // СохранитьНастройку()

// Процедура заполняет параметры отчета по элементу справочника из переменной СохраненнаяНастройка.
// 
Процедура ПрименитьНастройку() Экспорт
    
    // Применим настройки отчета.
    бит_БухгалтерскиеОтчетыСервер.ПрименитьСохраненнуюНастройку(ЭтотОбъект);
	
КонецПроцедуры // ПрименитьНастройку()

// Процедура заполняет начальные настройки построителя отчета.
// 
Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	ИмяРегистраБухгалтерии = РегистрБухгалтерии.ИмяОбъекта;
	
КонецПроцедуры // ЗаполнитьНачальныеНастройки

// Перезаполнение настроек построителя отчетов с сохранением пользовательских настроек.
// 
Процедура ПерезаполнитьНачальныеНастройки() Экспорт
	
	ЗаполнитьНачальныеНастройки();
    
КонецПроцедуры // ПерезаполнитьНачальныеНастройки()

#КонецОбласти

#Область Заголовки

// Функция формирует заголовок отчета (синоним).
// 
// Возвращаемое значение:
//  Строка - заголовок отчета.
// 
Функция ЗаголовокОтчета() Экспорт
	
	ПредставлениеРегистра = бит_ПраваДоступа.ПолучитьПредставлениеОбъектаСистемыИзСпискаЗначений(мСписокРегистров, РегистрБухгалтерии);
	
	ТекстЗаголовка = Нстр("ru = 'Оборотно-сальдовая ведомость (%1%)'");
	ТекстЗаголовка = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстЗаголовка, ПредставлениеРегистра);
	
	Возврат ТекстЗаголовка;
    
КонецФункции // ЗаголовокОтчета()

// Функция формирует табличный документа отчета и выполняет заполнение области "Заголовок".
// 
// Возвращаемое значение:
//  ТабличныйДокумент - табличный документ с заголовком.
// 
Функция СформироватьЗаголовок() Экспорт

    ОписаниеПериода = бит_БухгалтерскиеОтчетыСервер.СформироватьСтрокуВыводаПараметровПоДатам(Период.ДатаНачала, Период.ДатаОкончания);
	
	Макет = ПолучитьОбщийМакет("бит_ОборотноСальдоваяВедомость");
	
	ЗаголовокОтчета = Макет.ПолучитьОбласть("Заголовок");

	НазваниеОрганизации = бит_БухгалтерскиеОтчетыСервер.ПолучитьПолноеНазваниеОрганизации(Организация);
	
	ЗаголовокОтчета.Параметры.НазваниеОрганизации = НазваниеОрганизации;
	ЗаголовокОтчета.Параметры.Заголовок        	  = ЗаголовокОтчета();
	ЗаголовокОтчета.Параметры.ОписаниеПериода  	  = ОписаниеПериода;

	ТекстСписокПоказателей = Нстр("ru = 'Выводимые данные: '");
    
    Если ВыводитьСуммуРегл Тогда 
        ТекстСписокПоказателей = ТекстСписокПоказателей + Нстр("ru = 'сумма (регл.)'");
    КонецЕсли;
    Если ВыводитьСуммуУпр Тогда 
        ТекстСписокПоказателей = ТекстСписокПоказателей + ?(Найти(ТекстСписокПоказателей, "сумма") = 0, "", ", ") + Нстр("ru = 'сумма (упр.)'");
	КонецЕсли;
	Если мЕстьРесурсСуммаМУ И ВыводитьСуммуМУ Тогда 
        ТекстСписокПоказателей = ТекстСписокПоказателей + ?(Найти(ТекстСписокПоказателей, "сумма") = 0, "", ", ") + Нстр("ru = 'сумма (МСФО)'");
	КонецЕсли;
	Если ПоВалютам Тогда
		ТекстСписокПоказателей = ТекстСписокПоказателей + ?(Найти(ТекстСписокПоказателей, "сумма") = 0, "", ", ") + Нстр("ru = 'валютная сумма'");
	КонецЕсли;

    ЗаголовокОтчета.Параметры.СписокПоказателей = ТекстСписокПоказателей;

    // Вывод списка фильтров:
	СтрОтбор = бит_БухгалтерскиеОтчетыСервер.СформироватьСтрокуОтборов(ПостроительОтчета.Отбор);

	Если Не ПустаяСтрока(СтрОтбор) Тогда
		ОбластьОтбор = Макет.ПолучитьОбласть("СтрокаОтбор");
		ОбластьОтбор.Параметры.ТекстПроОтбор = Нстр("ru = 'Отбор: '") + СтрОтбор;
		ЗаголовокОтчета.Вывести(ОбластьОтбор);
	КонецЕсли;
    
	Возврат ЗаголовокОтчета;
	
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
	
	// Проверим наличие ресурса с именем "СуммаМУ".
	мЕстьРесурсСуммаМУ = бит_ОбщегоНазначения.ЕстьРесурсСуммаМУРегистраБухгалтерии(ИмяРегистраБухгалтерии);
	   	
	Если Не ПараметрыОтчетаКорректны() Тогда
		
		ОтчетСформирован = Ложь;
		
	Иначе
		
		ОтчетСформирован = Истина;
		
		бит_БухгалтерскиеОтчетыСервер.СформироватьОтчетОборотноСальдовойВедомости(ЭтотОбъект
																				, ДокументРезультат
																				, ПоказыватьЗаголовок
																				, ВысотаЗаголовка
																				, ПоВалютам
																				, Истина
																				, ПоЗабалансовымСчетам
																				, Неопределено); 

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
	
	Если мЕстьРесурсСуммаМУ И ВыводитьСуммуМУ Тогда 
        МассивПоказателей.Добавить("СуммаМУ");
    КонецЕсли;
	
	Если ПоВалютам Тогда
		МассивПоказателей.Добавить("ВалютнаяСумма");
	КонецЕсли;

	Возврат МассивПоказателей;
		
КонецФункции // СформироватьМассивПоказателей()

// Формирует запрос по установленным условия, фильтрам и группировкам.
// 
// Параметры:
//  СтруктураПараметров - Структура - параметры необходимые для формирования текста запроса.
// 
// Возвращаемое значение:
//  Запрос - запрос для формирования отчета.
// 
Функция СформироватьЗапрос(СтруктураПараметров) Экспорт

	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("НачПериода", НачалоДня(Период.ДатаНачала));
	Запрос.УстановитьПараметр("КонПериода", КонецДня(Период.ДатаОкончания));
	
	// БИТ Avseenkov 20.05.2014 Доработка отчетов по периметру
	//бит_БухгалтерскиеОтчетыСервер.УстановитьПараметрЗапроса_Организация(Запрос, Организация, Период);
	бит_БухгалтерскиеОтчетыСервер.УстановитьПараметрЗапроса_Организация(Запрос, Организация, Период, Истина);
	ТаблицаОрганизаций = бит_БухгалтерскиеОтчетыСервер.ПолучитьСоставПериметраКонсолидацииСУсловиями(Организация,Период.ДатаНачала, Период.ДатаОкончания); 
	//}
    
	ТекстЗапроса = "";
	ТекстИтогов  = "";
	
	// БИТ Avseenkov 20.05.2014 Доработка отчетов по периметру
	ТекстРазрешенные = "РАЗРЕШЕННЫЕ";
	ТекстКакВложенныйЗапрос = "";
	Если (ТипЗнч(Организация) = Тип("СправочникСсылка.бит_му_ПериметрыКонсолидации")) И ЗначениеЗаполнено(Организация) Тогда
		
		Если ТаблицаОрганизаций.Количество()> 0 Тогда 
			ТекстЗапроса = ТекстЗапроса +		
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ВложенныйЗапрос.Счет КАК Счет,
			|	ВложенныйЗапрос.Счет.Код КАК СчетКод,
			|	ВложенныйЗапрос.Счет.Наименование КАК СчетНаименование,
			|	ВложенныйЗапрос.Счет.Представление КАК СчетПредставление,
			|	ВложенныйЗапрос.Счет.Забалансовый КАК СчетЗабалансовый";
			
			Если ПоВалютам Тогда
				ТекстЗапроса = ТекстЗапроса + ",
				|	ВложенныйЗапрос.Валюта КАК Валюта,
				|	ВложенныйЗапрос.Валюта.Представление КАК ВалютаПредставление ";
				
			КонецЕсли;
			ТекстРазрешенные = "";
			ТекстЗапроса = ТекстЗапроса + бит_БухгалтерскиеОтчетыСервер.ВернутьЧастьЗапросаПоВыборкеПолейОборотноСальдоваяВедомостьБИТ(СтруктураПараметров.МассивПоказателей, Истина, Истина, Истина,,,,"ВложенныйЗапрос.");
			ТекстЗапроса = ТекстЗапроса + "
			| ИЗ
			| (";
			ТекстКакВложенныйЗапрос = ") как ВложенныйЗапрос
			|   ГДЕ НЕ ВложенныйЗапрос.Счет = ЗНАЧЕНИЕ(плансчетов.бит_Дополнительный_2.ПустаяСсылка)";
			
		КонецЕсли;
	КонецЕсли;
	//}
	
	ТекстЗапроса = ТекстЗапроса + 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Счет КАК Счет,
	|	Счет.Код КАК СчетКод,
	|	Счет.Наименование КАК СчетНаименование,
	|	Счет.Представление КАК СчетПредставление,
	|	Счет.Забалансовый КАК СчетЗабалансовый";

	Если ПоВалютам Тогда
		ТекстЗапроса = ТекстЗапроса + ",
		|	Валюта КАК Валюта,
		|	Валюта.Представление КАК ВалютаПредставление ";
	КонецЕсли;
    
    ТекстЗапроса = ТекстЗапроса + бит_БухгалтерскиеОтчетыСервер.ВернутьЧастьЗапросаПоВыборкеПолейОборотноСальдоваяВедомость(СтруктураПараметров.МассивПоказателей, Истина, Истина, Истина);
	ТекстИтогов  = ТекстИтогов  + бит_БухгалтерскиеОтчетыСервер.ВернутьЧастьЗапросаПоВыборкеПолейОборотноСальдоваяВедомость(СтруктураПараметров.МассивПоказателей, Ложь);		
    
	СтрокаТекстаВыборкиИзТаблицы = бит_БухгалтерскиеОтчетыСервер.СформироватьТекстВыборкиИзТаблицыОборотовИОстатковРегистраБухгалтерии(СтруктураПараметров,,, Запрос, ПостроительОтчета);
    
	ТекстЗапроса = ТекстЗапроса + СтрокаТекстаВыборкиИзТаблицы;
	
	// БИТ Avseenkov 20.05.2014 Доработка отчетов по периметру
	
	Если (ТипЗнч(Организация) = Тип("СправочникСсылка.бит_му_ПериметрыКонсолидации")) И ЗначениеЗаполнено(Организация) Тогда
		
		Если ТаблицаОрганизаций.Количество()> 0 Тогда 
			Сч = 0 ;
			СтруктураДанных = Новый Структура("ДатаНач,ДатаКон,Номер",НачалоДня(Период.ДатаНачала),КонецДня(Период.ДатаОкончания));
			Для Каждого Строка из ТаблицаОрганизаций цикл
				
				
				Сч = Сч + 1;
				СтруктураДанных.Номер = Сч;		
				
				
				ТекстЗапроса = ТекстЗапроса + " 
				| ОБЪЕДИНИТЬ ВСЕ
				|   ВЫБРАТЬ
				|	Счет КАК Счет,
				|	Счет.Код КАК СчетКод,
				|	Счет.Наименование КАК СчетНаименование,
				|	Счет.Представление КАК СчетПредставление,
				|	Счет.Забалансовый КАК СчетЗабалансовый";
				
				Если ПоВалютам Тогда
					ТекстЗапроса = ТекстЗапроса + ",
					|	Валюта КАК Валюта,
					|	Валюта.Представление КАК ВалютаПредставление ";
				КонецЕсли;
				
				ТекстЗапроса = ТекстЗапроса + бит_БухгалтерскиеОтчетыСервер.ВернутьЧастьЗапросаПоВыборкеПолейОборотноСальдоваяВедомостьБИТ(СтруктураПараметров.МассивПоказателей, Истина, Истина, Истина,,,Строка);
				СтрокаТекстаВыборкиИзТаблицы = бит_БухгалтерскиеОтчетыСервер.СформироватьТекстВыборкиИзТаблицыОборотовИОстатковРегистраБухгалтерии(СтруктураПараметров,,, Запрос, ПостроительОтчета,,Строка,СтруктураДанных);
				
				ТекстЗапроса  = ТекстЗапроса  + СтрокаТекстаВыборкиИзТаблицы;	
				
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	//}
	
	ТекстЗапроса = ТекстЗапроса + "
	|АВТОУПОРЯДОЧИВАНИЕ
	|ИТОГИ " + Сред(ТекстИтогов, 2) + "
	|ПО
	|	Счет ИЕРАРХИЯ";

	Если ПоВалютам Тогда
		ТекстЗапроса = ТекстЗапроса + ",
		|	Валюта КАК Валюта ";
	КонецЕсли;

	Запрос.Текст = ТекстЗапроса;

    // Установим текст построителя отчета для
    // возможности установления отбора.
    ПостроительОтчета.Текст = ТекстЗапроса;
    
	Возврат Запрос;

КонецФункции // СформироватьЗапрос()

// Функция возвращает общую структуру для расшифровки.
// 
// Возвращаемое значение:
//  Структура - общая структура расшифровки.
// 
Функция СформироватьОбщуюСтруктуруДляРасшифровки() Экспорт
	
	СтруктураНастроекОтчета = Новый Структура;

	СтруктураНастроекОтчета.Вставить("Период", Период);
	
	СтруктураНастроекОтчета.Вставить("Организация"             , Организация);
	СтруктураНастроекОтчета.Вставить("ОрганизацияВидСравнения" , ОрганизацияВидСравнения);
	СтруктураНастроекОтчета.Вставить("ОрганизацияИспользование", ОрганизацияИспользование);
    
    СтруктураНастроекОтчета.Вставить("ВыводитьСуммуРегл" , ВыводитьСуммуРегл);
    СтруктураНастроекОтчета.Вставить("ВыводитьСуммуУпр"  , ВыводитьСуммуУпр);
	СтруктураНастроекОтчета.Вставить("РегистрБухгалтерии", РегистрБухгалтерии);
	
	СтруктураНастроекОтчета.Вставить("ПоСубсчетамИСубконто", ПоСубсчетамИСубконто);
	СтруктураНастроекОтчета.Вставить("ПоСубсчетам"		   , ПоСубсчетамИСубконто);
	
	СтруктураНастроекОтчета.Вставить("ПоВалютам", ПоВалютам);
	
	Если мЕстьРесурсСуммаМУ Тогда
		СтруктураНастроекОтчета.Вставить("ВыводитьСуммуМУ", ВыводитьСуммуМУ);
	КонецЕсли;
	
    НастройкиОтбора = бит_БухгалтерскиеОтчетыСервер.ПолучитьКопиюОтбораВТЗ(ПостроительОтчета.Отбор);
	
	СтруктураНастроекОтчета.Вставить("Отбор", Новый ХранилищеЗначения(НастройкиОтбора));
    
	Возврат СтруктураНастроекОтчета;
	
КонецФункции // СформироватьОбщуюСтруктуруДляРасшифровки()

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проверки

// Проверка корректности настроек отчета
// 
// Возвращаемое значение:
//   Булево
// 
Функция ПараметрыОтчетаКорректны()
  	
	РезультатПроверки = 
		бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Период.ДатаНачала, Период.ДатаОкончания)
		И бит_БухгалтерскиеОтчетыСервер.ПроверитьНаличиеВыбранногоПоказателя(ЭтотОбъект, Ложь, мЕстьРесурсСуммаМУ)
		И Не бит_БухгалтерскиеОтчетыСервер.ОпределитьНаличиеДублирующегосяПараметраВИзмерениях(ПостроительОтчета);
	
	Возврат РезультатПроверки;
	
КонецФункции // ПараметрыОтчетаКорректны()

#КонецОбласти

#КонецОбласти

#Область Инициализация

СохраненнаяНастройка = Справочники.бит_СохраненныеНастройки.ПустаяСсылка();

// Сформируем список выбора регистров бухгалтерии.
мСписокРегистров = бит_УправленческийУчет.СформироватьСписокОбъектовДляВыбора(Перечисления.бит_ВидыОбъектовСистемы.РегистрБухгалтерии, "бит_Дополнительный");

мПрограммноеОткрытие = Ложь;
мЕстьРесурсСуммаМУ   = Ложь;

#КонецОбласти

#КонецЕсли
