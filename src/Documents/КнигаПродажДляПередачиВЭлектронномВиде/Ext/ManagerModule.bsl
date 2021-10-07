﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьОбъект(Объект, СтруктураПараметров) Экспорт

	ЗаполнениеДокументов.Заполнить(Объект, СтруктураПараметров);
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор());
	ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища);
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если СтруктураПараметров.ФорматПоПостановлению735 Тогда
		Объект.ДополнительныеСвойства.Вставить("АдресДанныхДляПередачи", АдресХранилища);
	Иначе
		
		СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
		Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		Если СтруктураДанных.Свойство("ТабличнаяЧасть") Тогда
			Объект.ТабличнаяЧасть.Загрузить(СтруктураДанных.ТабличнаяЧасть);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ПодготовитьДанныеДляЗаполнения(ПараметрыДляЗаполнения, АдресХранилища) Экспорт

	НачалоНалоговогоПериода = УчетНДСПереопределяемый.НачалоНалоговогоПериода(
		ПараметрыДляЗаполнения.Организация, ПараметрыДляЗаполнения.НалоговыйПериод);
		
	СписокОрганизаций = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьСписокОбособленныхПодразделений(
		ПараметрыДляЗаполнения.Организация);
		
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Организация",              ПараметрыДляЗаполнения.Организация);
	СтруктураПараметров.Вставить("НачалоПериода",            НачалоНалоговогоПериода);
	СтруктураПараметров.Вставить("КонецПериода",             КонецКвартала(ПараметрыДляЗаполнения.НалоговыйПериод));
	СтруктураПараметров.Вставить("СписокОрганизаций",        СписокОрганизаций);
	СтруктураПараметров.Вставить("ФорматПоПостановлению735", ПараметрыДляЗаполнения.ФорматПоПостановлению735);
	
	Если НЕ ПараметрыДляЗаполнения.ФорматПоПостановлению735 Тогда
		СтруктураПараметров.Вставить("ТабличнаяЧасть", 
			Документы.КнигаПродажДляПередачиВЭлектронномВиде.ПустаяСсылка().ТабличнаяЧасть.ВыгрузитьКолонки());
	КонецЕсли;

	СтруктураПараметров.Вставить("СформироватьОтчетПоСтандартнойФорме", Истина);
	СтруктураПараметров.Вставить("ОтбиратьПоКонтрагенту",               Ложь);
	СтруктураПараметров.Вставить("КонтрагентДляОтбора");
	СтруктураПараметров.Вставить("ГруппироватьПоКонтрагентам",          Ложь); 
	СтруктураПараметров.Вставить("ВыводитьПродавцовПоАвансам",          Ложь);
	СтруктураПараметров.Вставить("ВыводитьТолькоДопЛисты",              Ложь);
	СтруктураПараметров.Вставить("ФормироватьДополнительныеЛисты",      Ложь);
	СтруктураПараметров.Вставить("ДополнительныеЛистыЗаТекущийПериод",  Ложь); 
	СтруктураПараметров.Вставить("ДатаФормированияДопЛиста"); 
	СтруктураПараметров.Вставить("ЗаписьДополнительногоЛиста",          Ложь);
	СтруктураПараметров.Вставить("СкрытьКолонкиПоСтавке20",             Ложь);
	СтруктураПараметров.Вставить("ЕстьЗаписиПоКолонке20",               Ложь);
	СтруктураПараметров.Вставить("ЗаполнениеДокумента",                 Истина);
	СтруктураПараметров.Вставить("ЗаполнениеДекларации",                Ложь);
	СтруктураПараметров.Вставить("ВключатьОбособленныеПодразделения",   Истина);
	СтруктураПараметров.Вставить("ФормироватьТабличныйДокумент",        Истина);
	СтруктураПараметров.Вставить("ЭтоКнигаПродаж",                      Истина);

	ПроверкаКонтрагентов.ДобавитьОбщиеПараметрыДляПроверкиКонтрагентовВОтчете(СтруктураПараметров);
	
	Отчеты.КнигаПродаж.СформироватьОтчет(СтруктураПараметров, АдресХранилища);
	
КонецПроцедуры

Процедура ВосстановитьДанныеДляОтправки(ПараметрыВосстановления,АдресХранилища) Экспорт

	ДокументСсылка = ПараметрыВосстановления.ДокументСсылка;
	ПоместитьВоВременноеХранилище(ДокументСсылка.ПредставлениеОтчета.Получить(), АдресХранилища);

КонецПроцедуры

#КонецОбласти
 
#Область СлужебныеПроцедурыИФункции

// Функция поиска документа, относящегося к выбранному налоговому периоду.
//
// Параметры:
//  Организация     - СправочникСсылка.Организации.
//  НалоговыйПериод - Дата - налоговый период.
//
// Возвращаемое значение:
//  Массив, Неопределено - упорядоченный по дате массив документов.
//
Функция НайтиДокументыЗаНалоговыйПериод(Организация, НалоговыйПериод) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НалоговыйПериод) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",				Организация);
	Запрос.УстановитьПараметр("НачалоНалоговогоПериода",	НачалоКвартала(НалоговыйПериод));
	Запрос.УстановитьПараметр("КонецНалоговогоПериода",		КонецКвартала(НалоговыйПериод));
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КнигаПродажДляПередачиВЭлектронномВиде.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.КнигаПродажДляПередачиВЭлектронномВиде КАК КнигаПродажДляПередачиВЭлектронномВиде
	|ГДЕ
	|	КнигаПродажДляПередачиВЭлектронномВиде.Организация = &Организация
	|	И КнигаПродажДляПередачиВЭлектронномВиде.НалоговыйПериод >= &НачалоНалоговогоПериода
	|	И КнигаПродажДляПередачиВЭлектронномВиде.НалоговыйПериод <= &КонецНалоговогоПериода
	|	И НЕ КнигаПродажДляПередачиВЭлектронномВиде.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Результат	= Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МассивДокументов	= Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат МассивДокументов;

КонецФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Печать книги продаж.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "КнигаПродаж";
	КомандаПечати.Представление = НСтр("ru = 'Печать книги продаж'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "КнигаПродаж",
		НСтр("ru = 'Книга продаж'"), ПечатьКнигиПродаж(МассивОбъектов, ОбъектыПечати));
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	
	
КонецПроцедуры

Функция ПечатьКнигиПродаж(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТабличнаяЧастьКнигаПродаж.НомерСтроки,
	|	ТабличнаяЧастьКнигаПродаж.ДатаНомер,
	|	ТабличнаяЧастьКнигаПродаж.НомерДатаИсправления,
	|	ТабличнаяЧастьКнигаПродаж.НомерДатаКорректировки,
	|	ТабличнаяЧастьКнигаПродаж.НомерДатаИсправленияКорректировки,
	|	ТабличнаяЧастьКнигаПродаж.Покупатель,
	|	ТабличнаяЧастьКнигаПродаж.ПокупательИНН,
	|	ТабличнаяЧастьКнигаПродаж.ПокупательКПП,
	|	ТабличнаяЧастьКнигаПродаж.ДатаОплаты,
	|	ТабличнаяЧастьКнигаПродаж.ВсегоПродаж,
	|	ТабличнаяЧастьКнигаПродаж.СуммаБезНДС18,
	|	ТабличнаяЧастьКнигаПродаж.НДС18,
	|	ТабличнаяЧастьКнигаПродаж.СуммаБезНДС10,
	|	ТабличнаяЧастьКнигаПродаж.НДС10,
	|	ТабличнаяЧастьКнигаПродаж.НДС0,
	|	ТабличнаяЧастьКнигаПродаж.СуммаБезНДС20,
	|	ТабличнаяЧастьКнигаПродаж.НДС20,
	|	ТабличнаяЧастьКнигаПродаж.СуммаСовсемБезНДС,
	|	ТабличнаяЧастьКнигаПродаж.Ном,
	|	ТабличнаяЧастьКнигаПродаж.СчетФактура,
	|	КнигаПродажДляПередачиВЭлектронномВиде.Организация КАК Организация,
	|	КнигаПродажДляПередачиВЭлектронномВиде.НалоговыйПериод КАК НалоговыйПериод,
	|	КнигаПродажДляПередачиВЭлектронномВиде.СуммаБезНДС18 КАК СуммаБезНДС18Итог,
	|	КнигаПродажДляПередачиВЭлектронномВиде.НДС18 КАК НДС18Итог,
	|	КнигаПродажДляПередачиВЭлектронномВиде.СуммаБезНДС10 КАК СуммаБезНДС10Итог,
	|	КнигаПродажДляПередачиВЭлектронномВиде.НДС10 КАК НДС10Итог,
	|	КнигаПродажДляПередачиВЭлектронномВиде.НДС0 КАК НДС0Итог,
	|	КнигаПродажДляПередачиВЭлектронномВиде.СуммаСовсемБезНДС КАК СуммаСовсемБезНДСИтог,
	|	КнигаПродажДляПередачиВЭлектронномВиде.Ссылка КАК Ссылка,
	|	КнигаПродажДляПередачиВЭлектронномВиде.Организация.ИНН КАК ОрганизацияИНН,
	|	КнигаПродажДляПередачиВЭлектронномВиде.Организация.КПП КАК ОрганизацияКПП,
	|	КнигаПродажДляПередачиВЭлектронномВиде.ВсегоПродаж КАК ВсегоПродажИтог,
	|	КнигаПродажДляПередачиВЭлектронномВиде.ПредставлениеОтчета
	|ИЗ
	|	Документ.КнигаПродажДляПередачиВЭлектронномВиде КАК КнигаПродажДляПередачиВЭлектронномВиде
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КнигаПродажДляПередачиВЭлектронномВиде.ТабличнаяЧасть КАК ТабличнаяЧастьКнигаПродаж
	|		ПО (ТабличнаяЧастьКнигаПродаж.Ссылка = КнигаПродажДляПередачиВЭлектронномВиде.Ссылка)
	|ГДЕ
	|	КнигаПродажДляПередачиВЭлектронномВиде.Ссылка В(&МассивОбъектов)
	|ИТОГИ
	|	МАКСИМУМ(Организация),
	|	МАКСИМУМ(НалоговыйПериод),
	|	МАКСИМУМ(СуммаБезНДС18Итог),
	|	МАКСИМУМ(НДС18Итог),
	|	МАКСИМУМ(СуммаБезНДС10Итог),
	|	МАКСИМУМ(НДС10Итог),
	|	МАКСИМУМ(НДС0Итог),
	|	МАКСИМУМ(СуммаСовсемБезНДСИтог),
	|	МАКСИМУМ(ОрганизацияИНН),
	|	МАКСИМУМ(ОрганизацияКПП),
	|	МАКСИМУМ(ВсегоПродажИтог)
	|ПО
	|	Ссылка";
	
	Результат = Запрос.Выполнить();
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КнигаПродаж";
			
	ПервыйДокумент = Истина;
		
	ВыборкаПоОбъектам = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоОбъектам.Следующий() Цикл
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;

		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВерсияПостановленияНДС1137 = УчетНДСПереопределяемый.ВерсияПостановленияНДС1137(ВыборкаПоОбъектам.НалоговыйПериод);
		Если ВерсияПостановленияНДС1137 >= 3 Тогда
			ПредставлениеОтчета = ВыборкаПоОбъектам.ПредставлениеОтчета.Получить();
			Если ПредставлениеОтчета <> Неопределено Тогда 
				ТабличныйДокумент.Вывести(ПредставлениеОтчета);
			КонецЕсли;
			Продолжить;
		Иначе
			Макет = ПолучитьОбщийМакет("КнигаПродаж1137");
		КонецЕсли; 
		
		Секция = Макет.ПолучитьОбласть("ШапкаИнформация");
		ТабличныйДокумент.Вывести(Секция);
			
		Секция = Макет.ПолучитьОбласть("Шапка");
		
		Секция.Параметры.УстановленныйОтбор = "";
		Секция.Параметры.НачалоПериода = Формат(НачалоКвартала(ВыборкаПоОбъектам.НалоговыйПериод), "ДФ=dd.MM.yyyy");
		Секция.Параметры.КонецПериода = Формат(КонецКвартала(ВыборкаПоОбъектам.НалоговыйПериод), "ДФ=dd.MM.yyyy");
		
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаПоОбъектам.Организация);
		НазваниеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм");;
		
		Секция.Параметры.НазваниеОрганизации = НазваниеОрганизации;
		Секция.Параметры.ИННКППОрганизации = "" + ВыборкаПоОбъектам.ОрганизацияИНН 
			+ ?(НЕ ЗначениеЗаполнено(ВыборкаПоОбъектам.ОрганизацияКПП), "", ("/" + ВыборкаПоОбъектам.ОрганизацияКПП));
		
		ТабличныйДокумент.Вывести(Секция);
				
		ВыборкаТабличнойЧасти = ВыборкаПоОбъектам.Выбрать();
		
		Если ВыборкаТабличнойЧасти.Количество() = 0 Тогда
			
			Секция = Макет.ПолучитьОбласть("Всего");
			ТабличныйДокумент.Вывести(Секция);
			
			ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(ВыборкаПоОбъектам.Организация, КонецКвартала(ВыборкаПоОбъектам.НалоговыйПериод));
			Если ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(ВыборкаПоОбъектам.Организация) Тогда
				ИмяОрг = "";
				Свидетельство = "";
			Иначе
				ИмяОрг = ОтветственныеЛица.РуководительПредставление;
				СведенияОЮрФизЛице = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаПоОбъектам.Организация);
				Свидетельство = СведенияОЮрФизЛице.Свидетельство;
			КонецЕсли;
			
			Секция = Макет.ПолучитьОбласть("Подвал");
			Секция.Параметры.ИмяРук        = ОтветственныеЛица.РуководительПредставление;
			Секция.Параметры.ИмяОрг        = ИмяОрг;
			Секция.Параметры.Свидетельство = Свидетельство;
			
			ТабличныйДокумент.Вывести(Секция);
					
			УправлениеКолонтитулами.УстановитьКолонтитулы(ТабличныйДокумент);
			
		Иначе 
		
			Секция = Макет.ПолучитьОбласть("Строка");
			
			Пока ВыборкаТабличнойЧасти.Следующий() Цикл
				
				Секция.Параметры.Заполнить(ВыборкаТабличнойЧасти);
				ТабличныйДокумент.Вывести(Секция);		
				
			КонецЦикла;	
			
		КонецЕсли;	
				
		// Вывод всего
		Секция = Макет.ПолучитьОбласть("Всего");
				
		Секция.Параметры.ВсегоПродаж = ВыборкаПоОбъектам.ВсегоПродажИтог;
		Секция.Параметры.СуммаБезНДС18 = ВыборкаПоОбъектам.СуммаБезНДС18Итог;
		Секция.Параметры.НДС18 = ВыборкаПоОбъектам.НДС18Итог;
		Секция.Параметры.СуммаБезНДС10 = ВыборкаПоОбъектам.СуммаБезНДС10Итог;
		Секция.Параметры.НДС10 = ВыборкаПоОбъектам.НДС10Итог;
		Секция.Параметры.НДС0 = ВыборкаПоОбъектам.НДС0Итог;
		Секция.Параметры.СуммаСовсемБезНДС = ВыборкаПоОбъектам.СуммаСовсемБезНДСИтог;
				
		ТабличныйДокумент.Вывести(Секция);
		
		ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(ВыборкаПоОбъектам.Организация, КонецКвартала(ВыборкаПоОбъектам.НалоговыйПериод));
		Если ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(ВыборкаПоОбъектам.Организация) Тогда
			ИмяОрг = "";
			Свидетельство = "";
		Иначе
			ИмяОрг = ОтветственныеЛица.РуководительПредставление;
			СведенияОЮрФизЛице = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаПоОбъектам.Организация);
			Свидетельство = СведенияОЮрФизЛице.Свидетельство;
		КонецЕсли;
		
		Секция = Макет.ПолучитьОбласть("Подвал");
		Секция.Параметры.ИмяРук        = ОтветственныеЛица.РуководительПредставление;
		Секция.Параметры.ИмяОрг        = ИмяОрг;
		Секция.Параметры.Свидетельство = Свидетельство;
		
		ТабличныйДокумент.Вывести(Секция);
		
		ТабличныйДокумент.ПовторятьПриПечатиСтроки = ТабличныйДокумент.Область("СтрокиДляПовтора");
			
		УправлениеКолонтитулами.УстановитьКолонтитулы(ТабличныйДокумент);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент,
			НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоОбъектам.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли