﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ФормаВвода") тогда
		мОбъектДляЗаполнения =Параметры.ФормаВвода;	
	КонецЕсли;
	
	ЭтотОбъектЗнач = РеквизитФормыВЗначение("Объект");
	//ОКЕЙ Рычаков А.С.(СофтЛаб) Начало 2019-10-01 (#3490)
	//СхемаКомпоновкиДанных = ЭтотОбъектЗнач.ПолучитьМакет("МакетСКД");
	СхемаКомпоновкиДанных = ЭтотОбъектЗнач.ПолучитьМакет("ок_МакетСКД");
	//ОКЕЙ Рычаков А.С.(СофтЛаб) Конец 2019-10-01 (#3490)
	
	НаборДанныхСКД = СхемаКомпоновкиДанных.НаборыДанных[0];
	
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	
	Объект.КомпоновщикОтчета.Инициализировать(ИсточникНастроек);
	Объект.КомпоновщикОтчета.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	УстановитьЗаголовокЭлементовФормы();
	УстановитьВидимость();	
	
КонецПроцедуры

&НаСервере
Процедура 	УстановитьВидимость()
	
	Элементы.Отбор.Видимость = НЕ ОтображатьОтбор;
	Элементы.ФормаОтбор.Пометка = НЕ ОтображатьОтбор;
	
КонецПроцедуры



&НаСервере
Процедура ОбновитьНаСервере()

	Объект.ОборотыПоБюджетам.Очистить();
	
	МассивСтатейОборотов = Новый Массив;
	МассивСтатейОборотов.Добавить("ВсеСтатьиОборотов");
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	ПараметрыСКД = Объект.КомпоновщикОтчета.Настройки.ПараметрыДанных;
	
	ПараметрыСКД.УстановитьЗначениеПараметра("НачалоПериода"			, Объект.ДатаНачала);
	ПараметрыСКД.УстановитьЗначениеПараметра("КонецПериода"				, Новый Граница(КонецДня(Объект.ДатаОкончания), ВидГраницы.Включая));
	ПараметрыСКД.УстановитьЗначениеПараметра("Сценарий"					, Объект.Сценарий);
	ПараметрыСКД.УстановитьЗначениеПараметра("СтатьиОборотов"		, МассивСтатейОборотов);

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	НастройкиСКД = Объект.КомпоновщикОтчета.ПолучитьНастройки();
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
												НастройкиСКД,
												,
												,
												Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ТаблицаРезультат = Новый ТаблицаЗначений;
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Если НЕ ТаблицаРезультат.Количество() Тогда
		Сообщить("Нет данных, удовлетворяющих отбору.", СтатусСообщения.Информация);
		Возврат;
	КонецЕсли; 
	
	ЗаполнитьОборотыПоБюджетам(ТаблицаРезультат);
	
	
КонецПроцедуры

Процедура ЗаполнитьОборотыПоБюджетам(Результат) Экспорт

	// Получим структуру курсов валют.
	СтруктураКурсыВалют = бит_Бюджетирование.ПолучитьСтруктуруКурсовВалютСценария(мОбъектДляЗаполнения
																				 ,мОбъектДляЗаполнения.Дата
																				 ,Новый Структура("Документ, Сценарий"));
	// Получим размерность единицы измерения сумм документа.
	РазмерностьЕдиницы = бит_ОбщегоНазначения.ПолучитьРазмерностьЕдиницыИзмеренияСумм(мОбъектДляЗаполнения.ЕдиницаИзмеренияСумм);
	
	
	Для Каждого ВыборкаИзЗапроса Из Результат Цикл
		
		НоваяСтрока = Объект.ОборотыПоБюджетам.Добавить();
		
		// Заполним значения новой строки данными из выборки.
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаИзЗапроса);
		
		// Получим период для заполнения исходя от сдвига дат.
		НоваяСтрока.ПериодДляЗаполнения = бит_Бюджетирование.ПолучитьПериодПоСдвигу(НоваяСтрока.Период, 
																					Объект.СдвигДат, Объект.ПериодичностьРезультата);
																					
		// Рассчитаем сумму и количество для заполнения.
		РассчитатьСуммуДляЗаполненияВСтроке(НоваяСтрока);
		РассчитатьКоличествоДляЗаполненияВСтроке(НоваяСтрока);
		
		// Рассчитаем суммы в валюте документа.
		РассчитатьСуммуВВалютеДокументаВСтроке(НоваяСтрока, СтруктураКурсыВалют, РазмерностьЕдиницы);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьОборотыПоБюджетам()

Процедура РассчитатьСуммуДляЗаполненияВСтроке(ТекущаяСтрока) Экспорт
	
	Если Не ТекущаяСтрока.СтатьяОборотов.Учет_Сумма Тогда
		
		СуммаДляЗаполнения = 0;
		
	ИначеЕсли Объект.ВидОтклонения = Перечисления.бит_ВидыОтклоненийКонтрольныхЗначений.Процент Тогда
		
		СуммаДляЗаполнения = ТекущаяСтрока.СуммаСценарий + ТекущаяСтрока.СуммаСценарий * Объект.ЗначениеОтклонения / 100;
		
	ИначеЕсли Объект.ВидОтклонения = Перечисления.бит_ВидыОтклоненийКонтрольныхЗначений.Абсолютное Тогда
		
		СуммаДляЗаполнения = ТекущаяСтрока.СуммаСценарий + Объект.ЗначениеОтклонения;
		
	Иначе
		СуммаДляЗаполнения = ТекущаяСтрока.СуммаСценарий;
	КонецЕсли;
	
	ТекущаяСтрока.СуммаСценарийДляЗаполнения = СуммаДляЗаполнения;
	
КонецПроцедуры // РассчитатьСуммуДляЗаполненияВСтроке()

Процедура РассчитатьКоличествоДляЗаполненияВСтроке(ТекущаяСтрока) Экспорт
	
	Если Не ТекущаяСтрока.СтатьяОборотов.Учет_Количество Тогда
		
		КоличествоДляЗаполнения = 0;
		
	ИначеЕсли Объект.ВидОтклоненияКоличества = Перечисления.бит_ВидыОтклоненийКонтрольныхЗначений.Процент Тогда
		
		КоличествоДляЗаполнения = ТекущаяСтрока.Количество + ТекущаяСтрока.Количество * Объект.ЗначениеОтклоненияКоличества / 100;
		
	ИначеЕсли Объект.ВидОтклоненияКоличества = Перечисления.бит_ВидыОтклоненийКонтрольныхЗначений.Абсолютное Тогда
		
		КоличествоДляЗаполнения = ТекущаяСтрока.Количество + Объект.ЗначениеОтклоненияКоличества;
		
	Иначе
		КоличествоДляЗаполнения = ТекущаяСтрока.Количество;
	КонецЕсли;
	
	ТекущаяСтрока.КоличествоДляЗаполнения = КоличествоДляЗаполнения;
	
КонецПроцедуры // РассчитатьКоличествоДляЗаполненияВСтроке()

Процедура РассчитатьСуммуСценарийВВалютеДокументаВСтроке(ТекущаяСтрока) Экспорт
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Получим структуру курсов валют.
	СтруктураКурсыВалют = бит_Бюджетирование.ПолучитьСтруктуруКурсовВалютСценария(мОбъектДляЗаполнения
																				 ,мОбъектДляЗаполнения.Дата
																				 ,Новый Структура("Документ, Сценарий"));
	// Получим размерность единицы измерения сумм документа.
	РазмерностьЕдиницы = бит_ОбщегоНазначения.ПолучитьРазмерностьЕдиницыИзмеренияСумм(мОбъектДляЗаполнения.ЕдиницаИзмеренияСумм);
	
	// Выполним расчет суммы в валюте документа.
	РассчитатьСуммуВВалютеДокументаВСтроке(ТекущаяСтрока, СтруктураКурсыВалют, РазмерностьЕдиницы);
		
КонецПроцедуры // РассчитатьСуммуСценарийВВалютеДокументаВСтроке()

Процедура РассчитатьСуммыДляЗаполненияВОборотахПоБюджету() Экспорт
	
	Если Объект.ОборотыПоБюджетам.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Получим структуру курсов валют.
	СтруктураКурсыВалют = бит_Бюджетирование.ПолучитьСтруктуруКурсовВалютСценария(мОбъектДляЗаполнения
																				 ,мОбъектДляЗаполнения.Дата
																				 ,Новый Структура("Документ, Сценарий"));
	// Получим размерность единицы измерения сумм документа.
	РазмерностьЕдиницы = бит_ОбщегоНазначения.ПолучитьРазмерностьЕдиницыИзмеренияСумм(мОбъектДляЗаполнения.ЕдиницаИзмеренияСумм);
	
	// Выполним пересчет сумм для заполнения.
	Для Каждого ТекСтрока Из Объект.ОборотыПоБюджетам Цикл
		
		// Рассчитаем сумму для заполнения.
		РассчитатьСуммуДляЗаполненияВСтроке(ТекСтрока);
		
		// Выполним расчет суммы в валюте документа.
		РассчитатьСуммуВВалютеДокументаВСтроке(ТекСтрока, СтруктураКурсыВалют, РазмерностьЕдиницы);
		
	КонецЦикла;
	
КонецПроцедуры // РассчитатьСуммыДляЗаполненияВОборотахПоБюджету()

Процедура РассчитатьКоличествоДляЗаполненияВОборотахПоБюджету() Экспорт
	
	Если Объект.ОборотыПоБюджетам.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Выполним пересчет сумм для заполнения.
	Для Каждого ТекСтрока Из Объект.ОборотыПоБюджетам Цикл
		// Рассчитаем количество для заполнения.
		РассчитатьКоличествоДляЗаполненияВСтроке(ТекСтрока);
	КонецЦикла;
	
КонецПроцедуры // РассчитатьКоличествоДляЗаполненияВОборотахПоБюджету()

Процедура РассчитатьСуммуВВалютеДокументаВСтроке(ТекущаяСтрока, СтруктураКурсыВалют, РазмерностьЕдиницы) Экспорт
	
	СтруктураКурсовСценария 	   = СтруктураКурсыВалют.Сценарий;
	СтруктураКурсовВалютыДокумента = СтруктураКурсыВалют.Документ;
	
	// Расчитаем сумму в указанных единицах измерения сумм документа.
	СуммаВЕдиницеДокумента = бит_ОбщегоНазначения.ПересчитатьИзРазмерностиВРазмерность(ТекущаяСтрока.СуммаСценарийДляЗаполнения
																					  ,1
																					  ,РазмерностьЕдиницы);
	
	// Рассчитаем сумму в валюте документа.
	СуммаВВалютеДокумента = бит_КурсыВалютКлиентСервер.ПересчитатьИзВалютыВВалюту(СуммаВЕдиницеДокумента,
																			СтруктураКурсовСценария.Валюта,
																			СтруктураКурсовВалютыДокумента.Валюта,
																			СтруктураКурсовСценария.Курс,
																			СтруктураКурсовВалютыДокумента.Курс,
																			СтруктураКурсовСценария.Кратность,
																			СтруктураКурсовВалютыДокумента.Кратность);
	
	ТекущаяСтрока.СуммаСценарийВВалютеДокумента = СуммаВВалютеДокумента;
	
КонецПроцедуры // РассчитатьСуммуВВалютеДокументаВСтроке()


&НаКлиенте
Процедура Заполнить(Команда)
	а=1;
	
КонецПроцедуры


&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокЭлементовФормы()
		
	Если Не ЗначениеЗаполнено(Объект.ВидОтклонения)
		Или Объект.ВидОтклонения = Перечисления.бит_ВидыОтклоненийКонтрольныхЗначений.Абсолютное Тогда
		Элементы.ТипЗначения.Заголовок = Строка(Объект.Сценарий.Валюта);
		
	ИначеЕсли Объект.ВидОтклонения = Перечисления.бит_ВидыОтклоненийКонтрольныхЗначений.Процент Тогда
		Элементы.ТипЗначения.Заголовок = "%";     
		
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.ВидОтклонения) Тогда
		Элементы.ТипЗначения.Заголовок  = "";
		
	КонецЕсли;
	
	
КонецПроцедуры // УстановитьЗаголовокЭлементовФормы()

&НаКлиенте
Процедура ВидОтклоненияПриИзменении(Элемент)
	УстановитьЗаголовокЭлементовФормы();
	РассчитатьСуммыДляЗаполненияВОборотахПоБюджету();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеОтклоненияПриИзменении(Элемент)
		РассчитатьСуммыДляЗаполненияВОборотахПоБюджету();
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеОтклонения1ПриИзменении(Элемент)
	РассчитатьКоличествоДляЗаполненияВОборотахПоБюджету();
КонецПроцедуры

&НаКлиенте
Процедура ВидОтклоненияКоличестваПриИзменении(Элемент)
	
	
	Если Объект.ВидОтклоненияКоличества = ПредопределенноеЗначение("Перечисление.бит_ВидыОтклоненийКонтрольныхЗначений.Абсолютное") Тогда
		
		КвалификаторыЧисла = Новый КвалификаторыЧисла(15,3, ДопустимыйЗнак.Любой);
		Элементы.ЗначениеОтклоненияКоличества.ОграничениеТипа = Новый ОписаниеТипов("Число", КвалификаторыЧисла);
		
		ЗначениеОтклоненияКоличества = Элементы.ЗначениеОтклоненияКоличества.ОграничениеТипа.ПривестиЗначение(ЗначениеОтклоненияКоличества);
		
		Элементы.ТипЗначенияКоличества.Заголовок = "";
		
	ИначеЕсли Объект.ВидОтклоненияКоличества = ПредопределенноеЗначение("Перечисление.бит_ВидыОтклоненийКонтрольныхЗначений.Процент") Тогда
		
		КвалификаторыЧисла = Новый КвалификаторыЧисла(15,2, ДопустимыйЗнак.Любой);
		Элементы.ЗначениеОтклоненияКоличества.ОграничениеТипа = Новый ОписаниеТипов("Число", КвалификаторыЧисла);
		
		ЗначениеОтклоненияКоличества = Элементы.ЗначениеОтклоненияКоличества.ОграничениеТипа.ПривестиЗначение(ЗначениеОтклоненияКоличества);
		
		Если ЗначениеОтклоненияКоличества > 100 Тогда
			ЗначениеОтклоненияКоличества = 100;
		ИначеЕсли ЗначениеОтклоненияКоличества < -100 Тогда
			ЗначениеОтклоненияКоличества = -100;
		КонецЕсли;
		
		Элементы.ТипЗначенияКоличества.Заголовок = "%";
		
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.ВидОтклоненияКоличества) Тогда
		
		ЗначениеОтклоненияКоличества = 0;
		Элементы.ТипЗначенияКоличества.Заголовок = "";
		
	КонецЕсли;
	
	
	УстановитьЗаголовокЭлементовФормы();
	РассчитатьКоличествоДляЗаполненияВОборотахПоБюджету();
КонецПроцедуры

&НаКлиенте
Процедура Отбор(Команда)
	ОтображатьОтбор = НЕ ОтображатьОтбор;
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
	
	Если Объект.ЗапрашиватьПодтверждениеНаПеренос Тогда
		
		Ответ = Вопрос("Будет выполнено добавление данных бюджета
		|в документ """ + Строка(мОбъектДляЗаполнения) + """. Продолжить?", 
		РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Да);
		
	Иначе
		Ответ = КодВозвратаДиалога.Да;
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Адрес = ПолучитьАдресСтрокВХранилище();
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("СтрокиДляЗаполнения", Адрес);
		СтруктураПараметров.Вставить("РежимЗагрузки", "Добавление");
		
		ЭтаФорма.Закрыть(СтруктураПараметров);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если Объект.ЗапрашиватьПодтверждениеНаПеренос Тогда
		
		Ответ = Вопрос("Будет выполнена загрузка данных бюджета
		|в документ """ + Строка(мОбъектДляЗаполнения) + """. Продолжить?", 
		РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Да);
		
	Иначе
		Ответ = КодВозвратаДиалога.Да;
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Адрес = ПолучитьАдресСтрокВХранилище();
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("СтрокиДляЗаполнения", Адрес);
		СтруктураПараметров.Вставить("РежимЗагрузки", "Загрузка");
		
		ЭтаФорма.Закрыть(СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере 
Функция ПолучитьАдресСтрокВХранилище()
	
	Таблица = Объект.ОборотыПоБюджетам.Выгрузить();
	СтрокиДляЗаполнения = Таблица.НайтиСтроки(Новый Структура("Загрузить", Истина));
	
	Если СтрокиДляЗаполнения.Количество() = 0 Тогда
		Сообщить("Не указаны строки для добавления!");
		Возврат Неопределено;
	КонецЕсли;	
	
	Возврат ПоместитьВоВременноеХранилище(СтрокиДляЗаполнения, Новый УникальныйИдентификатор);
		
			
КонецФункции

&НаКлиенте
Процедура Отметить(Команда)
	
	Для Каждого Стр Из Объект.ОборотыПоБюджетам Цикл
		Стр.Загрузить = Истина;	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметки(Команда)
	
	Для Каждого Стр Из Объект.ОборотыПоБюджетам Цикл
		Стр.Загрузить = Ложь;	
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Инвертировать(Команда)
	
	Для Каждого Стр Из Объект.ОборотыПоБюджетам Цикл
		Стр.Загрузить = НЕ Стр.Загрузить;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	
	// Установка значений по умолчанию
	
	Если ТипЗнч(мОбъектДляЗаполнения) = Тип("ДокументСсылка.бит_ФормаВводаБюджета") Тогда
		
		ЭлементыОтбора = Объект.КомпоновщикОтчета.Настройки.Отбор.Элементы;
		
		Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			
			Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Аналитика_1") Тогда
				ЭлементОтбора.Использование = Истина;
				ЭлементОтбора.ПравоеЗначение = мОбъектДляЗаполнения.бит_БК_НомерЗаявки; 
			КонецЕсли;			
			
		КонецЦикла;
		
		Объект.Сценарий			 = мОбъектДляЗаполнения.бит_БК_НомерЗаявки.Сценарий;
		
		//+Сенин С.В. 27.09.16 №2618
		Если Не ЗначениеЗаполнено(мОбъектДляЗаполнения.бит_БК_НомерЗаявки)
			и Не ЗначениеЗаполнено(Объект.Сценарий)Тогда
			Объект.Сценарий = мОбъектДляЗаполнения.Сценарий;
		КонецЕсли;
		//-Сенин С.В. 27.09.16 №2618
		
		ТаблицаДляПериода =  мОбъектДляЗаполнения.бит_БК_НомерЗаявки.БДДС.Выгрузить();
		ТаблицаДляПериода.Сортировать("Период Возр",);
		
		Если ТаблицаДляПериода.Количество() Тогда
			Объект.ДатаНачала 		 = ТаблицаДляПериода[0].Период;	
			Объект.ДатаОкончания	 = КонецМесяца(ТаблицаДляПериода[ТаблицаДляПериода.Количество()-1].Период);	
		КонецЕсли;
		
		//БИТ АКриштопов 20.04.2016 ++
	ИначеЕсли ТипЗнч(мОбъектДляЗаполнения) = Тип("ДокументСсылка.бит_БюджетнаяОперация") Тогда
		ЭлементыОтбора = Объект.КомпоновщикОтчета.Настройки.Отбор.Элементы;
		
		Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			
			//ОКЕЙ Рычаков А.С.(СофтЛаб) Начало 2019-10-01 (#3490)
			//Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Аналитика_1") Тогда
			Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Аналитика_1") И ЗначениеЗаполнено(мОбъектДляЗаполнения.НомерЗаявки) Тогда
			//ОКЕЙ Рычаков А.С.(СофтЛаб) Конец 2019-10-01 (#3490)	
				ЭлементОтбора.Использование = Истина;
				ЭлементОтбора.ПравоеЗначение = мОбъектДляЗаполнения.НомерЗаявки; 
			КонецЕсли;			
			
		КонецЦикла;
		
		Объект.Сценарий			 = мОбъектДляЗаполнения.НомерЗаявки.Сценарий;
		
		ТаблицаДляПериода =  мОбъектДляЗаполнения.НомерЗаявки.БДДС.Выгрузить();
		ТаблицаДляПериода.Сортировать("Период Возр",);
		
		Если ТаблицаДляПериода.Количество() Тогда
			Объект.ДатаНачала 		 = ТаблицаДляПериода[0].Период;	
			Объект.ДатаОкончания	 = КонецМесяца(ТаблицаДляПериода[ТаблицаДляПериода.Количество()-1].Период);	
		КонецЕсли;
		//БИТ АКриштопов 20.04.2016 --
	КонецЕсли;

КонецПроцедуры



