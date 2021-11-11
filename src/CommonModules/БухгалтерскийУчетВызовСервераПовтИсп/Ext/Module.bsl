﻿#Область СвойстваСчетов

Функция ПолучитьСвойстваСчета(Знач Счет) Экспорт

	ДанныеСчета = Новый Структура;
	ДанныеСчета.Вставить("Ссылка"                         , ПланыСчетов.Хозрасчетный.ПустаяСсылка());
	ДанныеСчета.Вставить("Наименование"                   , "");
	ДанныеСчета.Вставить("Код"                            , "");
	ДанныеСчета.Вставить("КодБыстрогоВыбора"              , "");
	ДанныеСчета.Вставить("Порядок"                        , "");
	ДанныеСчета.Вставить("Родитель"                       , ПланыСчетов.Хозрасчетный.ПустаяСсылка());
	ДанныеСчета.Вставить("Вид"                            , Неопределено);
	ДанныеСчета.Вставить("Забалансовый"                   , Ложь);
	ДанныеСчета.Вставить("ЗапретитьИспользоватьВПроводках", Ложь);
	ДанныеСчета.Вставить("Валютный"                       , Ложь);
	ДанныеСчета.Вставить("Количественный"                 , Ложь);
	ДанныеСчета.Вставить("УчетПоПодразделениям"           , Ложь);
	ДанныеСчета.Вставить("НалоговыйУчет"                  , Ложь);
	ДанныеСчета.Вставить("КоличествоСубконто"             , 0);
	
	МаксКоличествоСубконто = БухгалтерскийУчет.МаксимальноеКоличествоСубконто();
	
	Для ИндексСубконто = 1 По МаксКоличествоСубконто Цикл
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто,                   Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Наименование",  Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТипЗначения",   Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Суммовой",      Ложь);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТолькоОбороты", Ложь);
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(Счет) Тогда
		Возврат ДанныеСчета;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Счет", Счет);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка,
	|	Хозрасчетный.Родитель,
	|	Хозрасчетный.Код,
	|	Хозрасчетный.КодБыстрогоВыбора,
	|	Хозрасчетный.Порядок,
	|	Хозрасчетный.Наименование,
	|	Хозрасчетный.Вид,
	|	Хозрасчетный.Забалансовый,
	|	Хозрасчетный.ЗапретитьИспользоватьВПроводках,
	|	Хозрасчетный.Валютный,
	|	Хозрасчетный.Количественный,
	|	Хозрасчетный.УчетПоПодразделениям,
	|	Хозрасчетный.НалоговыйУчет
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка = &Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйВидыСубконто.НомерСтроки КАК НомерСтроки,
	|	ХозрасчетныйВидыСубконто.ВидСубконто КАК ВидСубконто,
	|	ХозрасчетныйВидыСубконто.ВидСубконто.Наименование КАК Наименование,
	|	ХозрасчетныйВидыСубконто.ВидСубконто.ТипЗначения КАК ТипЗначения,
	|	ХозрасчетныйВидыСубконто.ТолькоОбороты КАК ТолькоОбороты,
	|	ХозрасчетныйВидыСубконто.Суммовой КАК Суммовой
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	|ГДЕ
	|	ХозрасчетныйВидыСубконто.Ссылка = &Счет
	|
	|УПОРЯДОЧИТЬ ПО
	|	ХозрасчетныйВидыСубконто.НомерСтроки";
	
	МассивРезультатов	= Запрос.ВыполнитьПакет();
	
	Выборка = МассивРезультатов[0].Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ДанныеСчета, Выборка);
	КонецЕсли;
		
	ВыборкаВидыСубконто	= МассивРезультатов[1].Выбрать();
		
	ДанныеСчета.КоличествоСубконто	= ВыборкаВидыСубконто.Количество();
		
	ИндексСубконто	= 0;
		
	Пока ВыборкаВидыСубконто.Следующий() Цикл
		
		ИндексСубконто	= ИндексСубконто + 1;
		
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто,                   ВыборкаВидыСубконто.ВидСубконто);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Наименование",  ВыборкаВидыСубконто.Наименование);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТипЗначения",   ВыборкаВидыСубконто.ТипЗначения);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Суммовой",      ВыборкаВидыСубконто.Суммовой);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТолькоОбороты", ВыборкаВидыСубконто.ТолькоОбороты);
		
	КонецЦикла;
	
	Возврат Новый ФиксированнаяСтруктура(ДанныеСчета);
	
КонецФункции

Функция НаСчетеВедетсяУчетПоНоменклатурнымГруппам(Счет) Экспорт
	
	СвойстваСчета = ПолучитьСвойстваСчета(Счет);
	
	УчетПоНомГруппам = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы;
	
	Возврат УчетПоНомГруппам;
	
КонецФункции

Функция НаСчетеВедетсяУчетПоРаботникам(Счет) Экспорт
	
	СвойстваСчета = ПолучитьСвойстваСчета(Счет);
	
	УчетПоРаботникам = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.РаботникиОрганизаций
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.РаботникиОрганизаций
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.РаботникиОрганизаций;
	
	Возврат УчетПоРаботникам;
	
КонецФункции

Функция НаСчетеВедетсяУчетПоПрочимДоходамИРасходам(Счет) Экспорт
	
	СвойстваСчета = ПолучитьСвойстваСчета(Счет);
	
	УчетПоПрочимДоходамИРасходам = СвойстваСчета.ВидСубконто1 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ПрочиеДоходыИРасходы
		ИЛИ СвойстваСчета.ВидСубконто2 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ПрочиеДоходыИРасходы
		ИЛИ СвойстваСчета.ВидСубконто3 = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ПрочиеДоходыИРасходы;
	
	Возврат УчетПоПрочимДоходамИРасходам;
	
КонецФункции

//Функция возвращает типы значений субконто, связанных с именами реквизитов.
//
// Возвращаемое значение:
//   Соответствие   - ключ - имя реквизита, значение - описание типов связанных значений субконто.
//
Функция ВсеТипыСвязанныхСубконто() Экспорт
	
	СвязанныеСубконто = Новый Соответствие;
	
	БухгалтерскийУчетПереопределяемый.УстановитьТипыСвязанныхСубконто(СвязанныеСубконто);
	
	СвязанныеСубконто.Вставить("Организация", БухгалтерскийУчетПереопределяемый.ТипыСвязанныеСОрганизацией());
	
	Возврат СвязанныеСубконто;
	
КонецФункции

//1c-izhtc spawn 13.08.15 (
// доработка
Функция ПолучитьСвойстваСчетаМУ(Знач Счет) Экспорт

	ДанныеСчета = Новый Структура;
	ДанныеСчета.Вставить("Ссылка"                         , ПланыСчетов.бит_Дополнительный_2.ПустаяСсылка());
	ДанныеСчета.Вставить("Наименование"                   , "");
	ДанныеСчета.Вставить("Код"                            , "");
	ДанныеСчета.Вставить("КодБыстрогоВыбора"              , "");
	ДанныеСчета.Вставить("Родитель"                       , ПланыСчетов.бит_Дополнительный_2.ПустаяСсылка());
	ДанныеСчета.Вставить("Вид"                            , Неопределено);
	ДанныеСчета.Вставить("Забалансовый"                   , Ложь);
	ДанныеСчета.Вставить("ЗапретитьИспользоватьВПроводках", Ложь);
	ДанныеСчета.Вставить("Валютный"                       , Ложь);
	ДанныеСчета.Вставить("Количественный"                 , Ложь);
	ДанныеСчета.Вставить("УчетПоПодразделениям"           , Ложь);
	ДанныеСчета.Вставить("НалоговыйУчет"                  , Ложь);
	ДанныеСчета.Вставить("КоличествоСубконто"             , 0);
	
	МаксКоличествоСубконто	= ПолучитьМаксКоличествоСубконтоМУ();
	
	Для ИндексСубконто = 1 По МаксКоличествоСубконто Цикл
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто,                   Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Наименование",  Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТипЗначения",   Неопределено);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Суммовой",      Ложь);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТолькоОбороты", Ложь);
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(Счет) Тогда
		Возврат ДанныеСчета;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Счет", Счет);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка,
	|	Хозрасчетный.Родитель,
	|	Хозрасчетный.Код,
	|	Хозрасчетный.КодБыстрогоВыбора,
	|	Хозрасчетный.Наименование,
	|	Хозрасчетный.Вид,
	|	Хозрасчетный.Забалансовый,
	|	Хозрасчетный.ЗапретитьИспользоватьВПроводках,
	|	Хозрасчетный.Валютный,
	|	Хозрасчетный.Количественный
	//|	Хозрасчетный.УчетПоПодразделениям,
	//|	Хозрасчетный.НалоговыйУчет
	|ИЗ
	|	ПланСчетов.бит_Дополнительный_2 КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка = &Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйВидыСубконто.НомерСтроки КАК НомерСтроки,
	|	ХозрасчетныйВидыСубконто.ВидСубконто КАК ВидСубконто,
	|	ХозрасчетныйВидыСубконто.ВидСубконто.Наименование КАК Наименование,
	|	ХозрасчетныйВидыСубконто.ВидСубконто.ТипЗначения КАК ТипЗначения,
	|	ХозрасчетныйВидыСубконто.ТолькоОбороты КАК ТолькоОбороты,
	|	ХозрасчетныйВидыСубконто.Суммовой КАК Суммовой
	|ИЗ
	|	ПланСчетов.бит_Дополнительный_2.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	|ГДЕ
	|	ХозрасчетныйВидыСубконто.Ссылка = &Счет
	|
	|УПОРЯДОЧИТЬ ПО
	|	ХозрасчетныйВидыСубконто.НомерСтроки";
	
	МассивРезультатов	= Запрос.ВыполнитьПакет();
	
	Выборка = МассивРезультатов[0].Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ДанныеСчета, Выборка);
	КонецЕсли;
		
	ВыборкаВидыСубконто	= МассивРезультатов[1].Выбрать();
		
	ДанныеСчета.КоличествоСубконто	= ВыборкаВидыСубконто.Количество();
		
	ИндексСубконто	= 0;
		
	Пока ВыборкаВидыСубконто.Следующий() Цикл
		
		ИндексСубконто	= ИндексСубконто + 1;
		
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто,                   ВыборкаВидыСубконто.ВидСубконто);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Наименование",  ВыборкаВидыСубконто.Наименование);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТипЗначения",   ВыборкаВидыСубконто.ТипЗначения);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "Суммовой",      ВыборкаВидыСубконто.Суммовой);
		ДанныеСчета.Вставить("ВидСубконто" + ИндексСубконто + "ТолькоОбороты", ВыборкаВидыСубконто.ТолькоОбороты);
		
	КонецЦикла;
	
	Возврат ДанныеСчета;
	
КонецФункции

Функция ПолучитьМаксКоличествоСубконтоМУ() Экспорт

	Возврат Метаданные.ПланыСчетов.бит_Дополнительный_2.МаксКоличествоСубконто;

КонецФункции
//1c-izhtc spawn 13.08.15 )

#КонецОбласти

#Область ИспользованиеОднойНоменклатурнойГруппы

// Функция возвращает признак использования одной номенклатурной группы.
//
Функция ИспользоватьОднуНоменклатурнуюГруппу() Экспорт

	Возврат НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоНоменклатурныхГрупп") 
		И ЗначениеЗаполнено(БухгалтерскийУчетВызовСервераПовтИсп.ОсновнаяНоменклатурнаяГруппа());

КонецФункции

// Функция получает единственную номенклатурную группу.
//
// Возвращаемое значение:
//		Основная номенклатурная группа - Тип НоменклатурныеГруппы, если ничего не найдено, то возвращается пустая ссылка.
Функция ОсновнаяНоменклатурнаяГруппа() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	НоменклатурныеГруппы.Ссылка
	|ИЗ
	|	Справочник.НоменклатурныеГруппы КАК НоменклатурныеГруппы
	|ГДЕ
	|	НЕ НоменклатурныеГруппы.ПометкаУдаления
	|	И НЕ НоменклатурныеГруппы.ЭтоГруппа";
	Выборка = Запрос.Выполнить().Выбрать();
	// Если опция ВестиУчетПоНесколькимНоменклатурнымГруппам выключена, но номенклатурная группа одна,
	// то все равно подставляем эту номенклатурную группу.
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		ОсновнаяНоменклатурнаяГруппа = Выборка.Ссылка;
	Иначе
		ОсновнаяНоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ОсновнаяНоменклатурнаяГруппа;

КонецФункции

#КонецОбласти

#Область ПервичныеДокументы

Функция ПользователюДоступныСуммыПостоянныхВременныхРазниц() Экспорт
	
	Возврат НалогНаПрибыльБухгалтерскийУчет.ПользователюДоступныСуммыРазниц();
	
КонецФункции

// Определяет в целом для сеанса работы, может ли потребоваться рассчитывать, заполнять и отображать в проводках
// пользователю суммы налогового учета и постоянных/временных разниц.
// 
// Возвращаемое значение:
//  Строка - варианты использования разниц:
//         * "ПоддержкаПБУ18", если может потребоваться использовать как НУ, так и суммы ПР/ВР в проводках;
//         * "ПлательщикНалогаНаПрибыль", если потребуются суммы НУ;
//         * "НеИспользовать", если ничего кроме сумм БУ не требуется использовать.
//
Функция ПользователюДоступныСуммыНалогНаПрибыль() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВидИспользованияСумм = "ПоддержкаПБУ18";
	Если Не БухгалтерскийУчет.ПользователюДоступныСуммыНУ() Тогда // только БУ
		ВидИспользованияСумм = "НеИспользовать";
	ИначеЕсли Не НалогНаПрибыльБухгалтерскийУчет.ПользователюДоступныСуммыРазниц() Тогда
		ВидИспользованияСумм = "ПлательщикНалогаНаПрибыль";
	КонецЕсли;
	
	Возврат ВидИспользованияСумм;
	
КонецФункции

#КонецОбласти

