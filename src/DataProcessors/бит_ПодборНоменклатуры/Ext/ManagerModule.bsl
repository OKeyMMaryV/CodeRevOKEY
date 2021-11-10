﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
	
// Функция инициализирует компоновщик.
// 
// Параметры:
//  Компоновщик              - КомпоновщикНастроекСхемыКомпоновкиДанных.
//  УникальныйИдентификатор  - УникальныйИдентификатор.
// 
// Возвращаемое значение:
//   АдресСхемыКомпоновкиДанных   - Строка.
// 
Функция ИнициализироватьКомпоновщик(Компоновщик, УникальныйИдентификатор, ИмяМакета) Экспорт

	СхемаКомпоновкиДанных = Обработки.бит_ПодборНоменклатуры.ПолучитьМакет(ИмяМакета);
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	
    Компоновщик.Инициализировать(ИсточникНастроек);
	Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);

	Возврат АдресСхемыКомпоновкиДанных;
	
КонецФункции // ИнициализироватьКомпоновщик()

// Функция выполняет запрос по настройке компновщика.
// 
// Параметры:
//  Компоновщик - КомпоновщикНастроекКомпоновкиДанных.
//  АдресСхемыКомпоновкиДанных - Строка.
//  СтруктураПараметров - Структура.
// 
// Возвращаемое значение:
//   Результат - РезультатЗапроса.
// 
Функция ВыполнитьЗапросПоНастройке(Компоновщик, АдресСхемыКомпоновкиДанных, СтруктураПараметров = Неопределено)  Экспорт

	 СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);

	// Выполняем компоновку макета МакетСКД
	// (настройки берутся из схемы компоновки данных и из пользовательских настроек).
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетСКД = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных, Компоновщик.ПолучитьНастройки());
	
	// Получаем запрос макета компоновки данных
	Запрос = Новый Запрос(МакетСКД.НаборыДанных.НаборДанных1.Запрос);
	
	// Устанавливаем параметры запроса
	ОписаниеПараметровЗапроса = Запрос.НайтиПараметры();
	Для каждого ОписаниеПараметраЗапроса из ОписаниеПараметровЗапроса Цикл
		Запрос.УстановитьПараметр(ОписаниеПараметраЗапроса.Имя, МакетСКД.ЗначенияПараметров[ОписаниеПараметраЗапроса.Имя].Значение);
	КонецЦикла;
	
	// Заполним параметры
	Если (СтруктураПараметров <> Неопределено) Тогда
		
		// Параметр дата начала
		Если (СтруктураПараметров.Свойство("ДатаНачала")) Тогда
			Запрос.УстановитьПараметр("НачалоПериода", СтруктураПараметров.ДатаНачала);
		КонецЕсли;

		// Параметр организация
		Если (СтруктураПараметров.Свойство("Организация")) Тогда
			Запрос.УстановитьПараметр("Организация", СтруктураПараметров.Организация);
		КонецЕсли;
		
		// Параметр документ
		Если (СтруктураПараметров.Свойство("Документ")) Тогда
			// Получим курсы валют, неоходимые для выполнения пересчетов.
			ВидыКурсов = Новый Структура("Упр,Регл,МУ,Документ");
			ДокументОбъект = ДанныеФормывЗначение(СтруктураПараметров.Документ, Тип("ДокументОбъект.бит_му_НачислениеРезерваПОМПЗ"));
			СтруктураКурсыВалют = бит_му_ОбщегоНазначения.ПолучитьСтруктуруКурсовВалют(ДокументОбъект, ДокументОбъект.Дата, ВидыКурсов);
			
            КУрсыМу  = СтруктураКурсыВалют.МУ;
			КурсыДок = СтруктураКурсыВалют.Документ;

			Коэффициент = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(1, КурсыМу.Валюта, 	КурсыДок.Валюта,
																			 КурсыМу.Курс, 		КурсыДок.Курс,
																			 КурсыМу.Кратность, КурсыДок.Кратность);
			
			Запрос.УстановитьПараметр("Коэффициент", Коэффициент);
		КонецЕсли;
		
	КонецЕсли;
	
	Результат = Запрос.Выполнить().Выгрузить();

	Возврат Результат;
	
КонецФункции // ВыполнитьЗапросПоНастройке()

// Функция выполняет запрос по настройке компновщика.
// 
// Параметры:
//  Компоновщик - КомпоновщикНастроекКомпоновкиДанных.
//  АдресСхемыКомпоновкиДанных - Строка.
//  СтруктураПараметров - Структура.
// 
// Возвращаемое значение:
//   Результат - РезультатЗапроса.
// 
Функция ВыполнитьЗапросСУчетомПросрочки(Компоновщик, АдресСхемыКомпоновкиДанных, СтруктураПараметров = Неопределено, ТаблицаРезультат) Экспорт

	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;

	// Выполняем компоновку макета МакетСКД
	// (настройки берутся из схемы компоновки данных и из пользовательских настроек).
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетСКД = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных, Компоновщик.ПолучитьНастройки());
	
	// Получаем запрос макета компоновки данных
	Запрос = Новый Запрос(МакетСКД.НаборыДанных.НаборДанных1.Запрос);
	
	// Устанавливаем параметры запроса
	ОписаниеПараметровЗапроса = Запрос.НайтиПараметры();
	Для каждого ОписаниеПараметраЗапроса из ОписаниеПараметровЗапроса Цикл
		Запрос.УстановитьПараметр(ОписаниеПараметраЗапроса.Имя, МакетСКД.ЗначенияПараметров[ОписаниеПараметраЗапроса.Имя].Значение);
	КонецЦикла;
	
	// Параметр массив субконто
	МассивСубконто 	= Новый Массив;
	ВидыСубконто 	= ПланыВидовХарактеристик.бит_ВидыСубконтоДополнительные_2;
	МассивСубконто.Добавить(ВидыСубконто.Номенклатура);
	МассивСубконто.Добавить(ВидыСубконто.Склады);
	
	Запрос.УстановитьПараметр("МассивСубконто", МассивСубконто);
	
	КонечнаяДата = СтруктураПараметров.ДатаНачала;
	Организация = СтруктураПараметров.Организация;
	
	// Заполним параметры
	Если (СтруктураПараметров <> Неопределено) Тогда
		
		// Параметр дата начала
		Если (СтруктураПараметров.Свойство("НачалоПериода")) Тогда
			Запрос.УстановитьПараметр("НачалоПериода", КонечнаяДата);
		КонецЕсли;

		// Параметр организация
		Если (СтруктураПараметров.Свойство("Организация")) Тогда
			Запрос.УстановитьПараметр("Организация", Организация);
		КонецЕсли;
		
	КонецЕсли;
	
	Остатки = Запрос.Выполнить().Выгрузить();

	СводнаяТаблица = Остатки.Скопировать();
	СводнаяТаблица.Очистить();
	СводнаяТаблица.Колонки.Добавить("КоличествоДнейПросрочки"	, Новый ОписаниеТипов("Число"));
	СводнаяТаблица.Колонки.Добавить("Процент"					, Новый ОписаниеТипов("Число"));
	СводнаяТаблица.Колонки.Добавить("СчетУчетаРезерва"			, Новый ОписаниеТипов("ПланСчетовСсылка.бит_Дополнительный_2"));
	
	ЗапросОбороты = Новый Запрос;
	ЗапросОбороты.МенеджерВременныхТаблиц = МенеджерВТ;
	ЗапросОбороты.УстановитьПараметр("Организация"		, Организация);
	ЗапросОбороты.УстановитьПараметр("КонецПериода"		, КонечнаяДата);
	
	ЗапросОборотыТекст = "
	|ВЫБРАТЬ
	|	ТаблицаОстатков.Себестоимость,
	|	ТаблицаОстатков.СчетУчета,
	|	ТаблицаОстатков.Номенклатура,
	|	ТаблицаОстатков.НоменклатурнаяГруппа,
	|	ТаблицаОстатков.Склад,
	|	ТаблицаОстатков.ЕдиницаИзмерения,
	|	ТаблицаОстатков.СебестоимостьЕдиницы,
	|	ТаблицаОстатков.Количество,
	|	ТаблицаОстатков.КоличествоДнейПросрочки,
	|	ТаблицаОстатков.Процент,
	|	ТаблицаОстатков.СчетУчетаРезерва
	|ПОМЕСТИТЬ Остатки
	|ИЗ
	|	&ТаблицаОстатков КАК ТаблицаОстатков";
	
	инд=0;					 
	
	// Извлекаем настройки учетной политики МСФО
	ТекУчетнаяПолитика 	= бит_му_ОбщегоНазначения.ПолучитьУчетнуюПолитику(ТекущаяДата(), Новый Структура("Организация", Организация));
	Календарь 			= бит_ОбщегоНазначения.ИзвлечьНастройкуПрограммы(ТекУчетнаяПолитика, ПланыВидовХарактеристик.бит_му_ВидыПараметровУчетнойПолитики.Календарь);
	РасчетРезервов 		= бит_ОбщегоНазначения.ИзвлечьНастройкуПрограммы(ТекУчетнаяПолитика, ПланыВидовХарактеристик.бит_му_ВидыПараметровУчетнойПолитики.РасчетРезервовМПЗ);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	бит_му_ПараметрыРасчетаРезервовМПЗ.Организация КАК Организация,
	|	бит_му_ПараметрыРасчетаРезервовМПЗ.КоличествоДнейПросрочки КАК КоличествоДнейПросрочки,
	|	бит_му_ПараметрыРасчетаРезервовМПЗ.Процент,
	|	бит_му_ПараметрыРасчетаРезервовМПЗ.СчетУчетаРезерва
	|ИЗ
	|	РегистрСведений.бит_му_ПараметрыРасчетаРезервовМПЗ КАК бит_му_ПараметрыРасчетаРезервовМПЗ
	|ГДЕ
	|	бит_му_ПараметрыРасчетаРезервовМПЗ.Организация = &Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	бит_му_ПараметрыРасчетаРезервовМПЗ.Организация,
	|	бит_му_ПараметрыРасчетаРезервовМПЗ.КоличествоДнейПросрочки,
	|	бит_му_ПараметрыРасчетаРезервовМПЗ.Процент,
	|	бит_му_ПараметрыРасчетаРезервовМПЗ.СчетУчетаРезерва
	|ИЗ
	|	РегистрСведений.бит_му_ПараметрыРасчетаРезервовМПЗ КАК бит_му_ПараметрыРасчетаРезервовМПЗ
	|ГДЕ
	|	бит_му_ПараметрыРасчетаРезервовМПЗ.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	КоличествоДнейПросрочки УБЫВ";
	
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	
	ТаблицаКоличествоДней = ТаблицаДанных.Скопировать();
	ТаблицаКоличествоДней.Свернуть("КоличествоДнейПросрочки");
	
	Для Каждого СтрРезультат Из ТаблицаКоличествоДней Цикл
		
		инд=инд+1;
		
		ЗапросОборотыТекст = ЗапросОборотыТекст + Символы.ПС + ";";
		
		СтрОтбор = Новый Структура("Организация, КоличествоДнейПросрочки", Организация, СтрРезультат.КоличествоДнейПросрочки);
		МассивСтрок = ТаблицаДанных.НайтиСтроки(СтрОтбор);
		
		Если МассивСтрок.Количество()=0 Тогда
			
			СтрОтбор = Новый Структура("Организация, КоличествоДнейПросрочки", Справочники.Организации.ПустаяСсылка(), СтрРезультат.КоличествоДнейПросрочки);
			МассивСтрок = ТаблицаДанных.НайтиСтроки(СтрОтбор);
			
		КонецЕсли; 
		
		СтрЗначения = МассивСтрок[0];
		
		Для каждого СтрОстатки Из Остатки Цикл
		
			НоваяСтрокаТаблицы = СводнаяТаблица.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаТаблицы,СтрОстатки);
			ЗаполнитьЗначенияСвойств(НоваяСтрокаТаблицы,СтрЗначения);
		
		КонецЦикла; 
		
		Если РасчетРезервов = Перечисления.бит_му_РасчетРезервовМПЗ.СУчетомВыходных Тогда
		
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
			Запрос.УстановитьПараметр("ВидДня"						, Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий);
			Запрос.УстановитьПараметр("ПроизводственныйКалендарь"	, Календарь);
			Запрос.УстановитьПараметр("ДатаДокумента"				, КонечнаяДата);
			ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ВложенныйЗапрос.ПроизводственныйКалендарь КАК ПроизводственныйКалендарь,
			|	МИНИМУМ(ВложенныйЗапрос.Дата) КАК Дата
			|ИЗ
			|	(ВЫБРАТЬ ПЕРВЫЕ 10
			|		ДанныеКалендаря.ПроизводственныйКалендарь КАК ПроизводственныйКалендарь,
			|		ДанныеКалендаря.Дата КАК Дата
			|	ИЗ
			|		РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеКалендаря
			|	ГДЕ
			|		ДанныеКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь
			|		И ДанныеКалендаря.ВидДня = &ВидДня
			|		И ДанныеКалендаря.Дата <= &ДатаДокумента
			|	
			|	УПОРЯДОЧИТЬ ПО
			|		Дата УБЫВ) КАК ВложенныйЗапрос
			|
			|СГРУППИРОВАТЬ ПО
			|	ВложенныйЗапрос.ПроизводственныйКалендарь";
			
			Схема = Новый СхемаЗапроса;
			Схема.УстановитьТекстЗапроса(ТекстЗапроса);
			
			// Берем столько записей, сколько в регистре количество дней просрочки.
			ОператорСхемы = Схема.ПакетЗапросов[0].Операторы[0].Источники[0].Источник.Запрос.Операторы.Получить(0);
			ОператорСхемы.КоличествоПолучаемыхЗаписей = СтрРезультат.КоличествоДнейПросрочки;
			
			Запрос.Текст = Схема.ПолучитьТекстЗапроса();
			
			Результат = Запрос.Выполнить().Выгрузить();
			
			// Чтобы не было ситуации, когда количество дней просрочки выходит за количество
			// записей в регистре ПроизводственныйКалендарь, тогда берем просто разность дат.
			ДатаКалендарная = ПолучитьКалендарнуюДату(КонечнаяДата, СтрРезультат.КоличествоДнейПросрочки);
			
			Если Результат.Количество()>0 Тогда
			
				НачальнаяДата = ?(ДатаКалендарная > Результат[0].Дата, Результат[0].Дата, ДатаКалендарная);
			Иначе	
				НачальнаяДата = ДатаКалендарная;
			КонецЕсли; 
			
		Иначе	
			НачальнаяДата = ПолучитьКалендарнуюДату(КонечнаяДата, СтрРезультат.КоличествоДнейПросрочки);
		КонецЕсли; 
		
		ЗапросОбороты.УстановитьПараметр("НачалоПериода" + инд	, НачальнаяДата);
		ЗапросОбороты.УстановитьПараметр("КоличествоДнейПросрочки"+инд, СтрЗначения.КоличествоДнейПросрочки);
		
		ЗапросОборотыТекст = ЗапросОборотыТекст + Символы.ПС +	"
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	бит_Дополнительный_2Обороты.СуммаМУОборотКт КАК СуммаОборотКт,
		|	Остатки.Себестоимость,
		|	Остатки.СчетУчета,
		|	Остатки.Номенклатура,
		|	Остатки.НоменклатурнаяГруппа,
		|	Остатки.Склад,
		|	Остатки.ЕдиницаИзмерения,
		|	Остатки.СебестоимостьЕдиницы,
		|	Остатки.Количество,
		|	Остатки.Процент,
		|	Остатки.КоличествоДнейПросрочки,
		|	Остатки.СчетУчетаРезерва,
		|	&НачалоПериода"+инд+" КАК НачалоПериода
		|ИЗ
		|	Остатки КАК Остатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.бит_Дополнительный_2.Обороты(&НачалоПериода"+инд+" {(&НачалоПериода"+инд+")}, &КонецПериода {(&КонецПериода)}, Период, , , Организация = &Организация, , ) КАК бит_Дополнительный_2Обороты
		|		ПО Остатки.СчетУчета = бит_Дополнительный_2Обороты.КорСчет
		|			И Остатки.Номенклатура = бит_Дополнительный_2Обороты.КорСубконто1
		|			И Остатки.Склад = бит_Дополнительный_2Обороты.КорСубконто2
		|ГДЕ
		|	Остатки.КоличествоДнейПросрочки = &КоличествоДнейПросрочки"+инд;

	КонецЦикла;
	
	ЗапросОбороты.Текст = ЗапросОборотыТекст;
	ЗапросОбороты.УстановитьПараметр("ТаблицаОстатков"	, СводнаяТаблица);
	
	РезультатПакеты = ЗапросОбороты.ВыполнитьПакет();
	
	ЭтоПервый = Истина;
	Для каждого Пакет Из РезультатПакеты Цикл
		
		Если ЭтоПервый Тогда
		    ЭтоПервый = Ложь;
			Продолжить;
		КонецЕсли; 
		
		ВыборкаОбороты = Пакет.Выбрать();
		
		Пока ВыборкаОбороты.Следующий() Цикл
		
			Если ВыборкаОбороты.СуммаОборотКт = NULL Тогда
				
				// Проверяем что строки нет в таблице, чтобы не было дублей с наименьшим периодом.
				СтрОтборРезультат = Новый Структура("СчетУчета, Номенклатура, Склад"	, ВыборкаОбороты.СчетУчета
																						, ВыборкаОбороты.Номенклатура
																						, ВыборкаОбороты.Склад);
				МассивСтрокРезультат = ТаблицаРезультат.НайтиСтроки(СтрОтборРезультат);
				
				Если МассивСтрокРезультат.Количество()=0 Тогда
				
					НоваяСтрока = ТаблицаРезультат.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаОбороты);
					НоваяСтрока.Резерв = ВыборкаОбороты.Себестоимость * ВыборкаОбороты.Процент / 100;
					НоваяСтрока.Использование = Истина;
					
					Если НЕ ЗначениеЗаполнено(СтрЗначения.СчетУчетаРезерва) Тогда
					
						СтруктураПараметров = Новый Структура("Организация, Номенклатура, Склад, Возвращать", 
															  Организация,
															  ВыборкаОбороты.Номенклатура,
															  ВыборкаОбороты.Склад);
															  
						СчетаУчета = бит_му_МПЗ.ПолучитьСчетаУчетаНоменклатуры(СтруктураПараметров);	
																								
						НоваяСтрока.СчетРезерва = СчетаУчета.СчетРезерва;																		
						
					Иначе	
						НоваяСтрока.СчетРезерва = ВыборкаОбороты.СчетУчетаРезерва;																		
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла; 
		
	КонецЦикла; 
	
КонецФункции // ВыполнитьЗапросСУчетомПросрочки()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция получает календарную дату.
//
// Параметры:
//  ДатаНачала - Дата.
//  КоличествоДней - Число.
//
// Возвращаемое значение:
//  Результат - Дата.
//
Функция ПолучитьКалендарнуюДату(ДатаНачала, КоличествоДней)

	Возврат ДатаНачала - 60*60*24*КоличествоДней;
	
КонецФункции // ПолучитьКалендарнуюДату()

#КонецОбласти

#КонецЕсли
