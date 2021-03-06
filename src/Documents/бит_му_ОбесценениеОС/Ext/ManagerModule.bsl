#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
		
	// Расчет амортизации.
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор				= "РасчетАмортизации";
	КомандаПечати.Представление				= НСтр("ru = 'Расчет амортизации'");
	КомандаПечати.Обработчик				= "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок					= 10;		
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РасчетАмортизации") Тогда					
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "РасчетАмортизации", НСтр("ru = 'Расчет амортизации'"), 
			ПечатьРасчетаАмортизации(МассивОбъектов),,"Документ.бит_му_ОбесценениеОС.РасчетАмортизации");
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция готовит таблицы документа для проведения.
// 
// Возвращаемое значение:
//   ТаблицаБДДС   - ТаблицаЗначений.
// 
Функция ПодготовитьТаблицыДокумента(Объект, СтруктураШапкиДокумента)  Экспорт
	
	МассивОС = Объект.ОсновныеСредства.ВыгрузитьКолонку("ОсновноеСредство");
	бит_РаботаСКоллекциями.УдалитьПовторяющиесяЭлементыМассива(МассивОС);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка"       ,Объект.Ссылка);
	Запрос.УстановитьПараметр("МассивОС"     ,МассивОС);
	Запрос.УстановитьПараметр("Организация"  ,Объект.Организация);
	Запрос.УстановитьПараметр("МоментВремени",Объект.МоментВремени());
	Запрос.УстановитьПараметр("НачалоПериода",НачалоМесяца(СтруктураШапкиДокумента.Дата));
	Запрос.УстановитьПараметр("КонецПериода" ,КонецМесяца(СтруктураШапкиДокумента.Дата));
	Если СтруктураШапкиДокумента.ВидДвижения = Перечисления.бит_му_ВидыДвиженияОбесценения.ВозвратОбесценения Тогда
		Запрос.УстановитьПараметр("ЭтоВозвратОбесценения",Истина);
	Иначе	
		Запрос.УстановитьПараметр("ЭтоВозвратОбесценения",Ложь);
	КонецЕсли; 
	
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-06-08 (#4146)
	Запрос.УстановитьПараметр("ПВХ_НачислятьАмортизацию_ОС" , ПланыВидовХарактеристик.бит_му_ВидыПараметровВНА.НачислятьАмортизацию_ОС);
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-06-08 (#4146)
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА бит_му_ПараметрыОССрезПоследних.Параметр = ЗНАЧЕНИЕ(ПланВидовХарактеристик.бит_му_ВидыПараметровВНА.ЛиквидационнаяСтоимость_ОС)
	|				ТОГДА бит_му_ПараметрыОССрезПоследних.ЗначениеПараметра
	|			ИНАЧЕ NULL
	|		КОНЕЦ) КАК ЛиквидационнаяСтоимость,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА бит_му_ПараметрыОССрезПоследних.Параметр = ЗНАЧЕНИЕ(ПланВидовХарактеристик.бит_му_ВидыПараметровВНА.Класс_ОС)
	|				ТОГДА бит_му_ПараметрыОССрезПоследних.ЗначениеПараметра
	|			ИНАЧЕ NULL
	|		КОНЕЦ) КАК Класс,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА бит_му_ПараметрыОССрезПоследних.Параметр = ЗНАЧЕНИЕ(ПланВидовХарактеристик.бит_му_ВидыПараметровВНА.ФинансоваяАренда_ОС)
	|				ТОГДА бит_му_ПараметрыОССрезПоследних.ЗначениеПараметра
	|			ИНАЧЕ NULL
	|		КОНЕЦ) КАК ОбъектВФинансовойАренде,
	|	бит_му_ПараметрыОССрезПоследних.ОсновноеСредство
	|ПОМЕСТИТЬ ТаблицаПараметров
	|ИЗ
	|	РегистрСведений.бит_му_ПараметрыОС.СрезПоследних(
	|			&МоментВремени,
	|			ОсновноеСредство В (&МассивОС)
	|				И Организация = &Организация
	|				И (Параметр = ЗНАЧЕНИЕ(ПланВидовХарактеристик.бит_му_ВидыПараметровВНА.ЛиквидационнаяСтоимость_ОС)
	|					ИЛИ Параметр = ЗНАЧЕНИЕ(ПланВидовХарактеристик.бит_му_ВидыПараметровВНА.Класс_ОС)
	|					ИЛИ Параметр = ЗНАЧЕНИЕ(ПланВидовХарактеристик.бит_му_ВидыПараметровВНА.ФинансоваяАренда_ОС))) КАК бит_му_ПараметрыОССрезПоследних
	|
	|СГРУППИРОВАТЬ ПО
	|	бит_му_ПараметрыОССрезПоследних.ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ДатыМодернизации.ОсновноеСредство, ДатыФормированияРезерва.ОсновноеСредство) КАК ОсновноеСредство,
	|	ЕСТЬNULL(ДатыМодернизации.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК ПериодМодернизации,
	|	МИНИМУМ(ЕСТЬNULL(ДатыФормированияРезерва.Период, ДАТАВРЕМЯ(1, 1, 1))) КАК ПериодФормированияРезерва
	|ПОМЕСТИТЬ ПериодыМодернизации
	|ИЗ
	|	РегистрСведений.бит_му_СобытияОС.СрезПоследних(
	|			&МоментВремени,
	|			&ЭтоВозвратОбесценения = ИСТИНА
	|				И Организация = &Организация
	|				И Событие = ЗНАЧЕНИЕ(Перечисление.бит_му_СобытияОС.Модернизация)
	|				И ОсновноеСредство В (&МассивОС)) КАК ДатыМодернизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_му_СобытияОС КАК ДатыФормированияРезерва
	|		ПО ДатыМодернизации.Организация = ДатыФормированияРезерва.Организация
	|			И ДатыМодернизации.ОсновноеСредство = ДатыФормированияРезерва.ОсновноеСредство
	|			И ДатыМодернизации.Период < ДатыФормированияРезерва.Период
	|			И (ДатыФормированияРезерва.Событие = ЗНАЧЕНИЕ(Перечисление.бит_му_СобытияОС.ФормированиеРезерва))
	|			И (ДатыФормированияРезерва.ОсновноеСредство В (&МассивОС))
	|			И (ДатыФормированияРезерва.Организация = &Организация)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЕСТЬNULL(ДатыМодернизации.ОсновноеСредство, ДатыФормированияРезерва.ОсновноеСредство),
	|	ЕСТЬNULL(ДатыМодернизации.Период, ДАТАВРЕМЯ(1, 1, 1))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-06-08 (#4146
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	бит_му_ПараметрыОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство
	|ПОМЕСТИТЬ ВТ_НеНачислятьАмортизацию
	|ИЗ
	|	РегистрСведений.бит_му_ПараметрыОС.СрезПоследних(
	|			,
	|			Организация = &Организация
	|				И ОсновноеСредство В (&МассивОС)
	|				И Параметр = &ПВХ_НачислятьАмортизацию_ОС) КАК бит_му_ПараметрыОССрезПоследних
	|ГДЕ
	|	бит_му_ПараметрыОССрезПоследних.ЗначениеПараметра = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////)
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-06-08 (#4146)
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	бит_му_СобытияОС.ОсновноеСредство
	|ПОМЕСТИТЬ НачисленаАмортизацияТекущий
	|ИЗ
	|	РегистрСведений.бит_му_СобытияОС КАК бит_му_СобытияОС
	|ГДЕ
	|	бит_му_СобытияОС.Организация = &Организация
	|	И бит_му_СобытияОС.Событие = ЗНАЧЕНИЕ(Перечисление.бит_му_СобытияОс.НачислениеАмортизации)
	|	И бит_му_СобытияОС.ОсновноеСредство В(&МассивОС)
	|	И бит_му_СобытияОС.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	бит_му_СобытияОС.ОсновноеСредство
	|ПОМЕСТИТЬ НачисленаАмортизацияСледующий
	|ИЗ
	|	РегистрСведений.бит_му_СобытияОС КАК бит_му_СобытияОС
	|ГДЕ
	|	бит_му_СобытияОС.Организация = &Организация
	|	И бит_му_СобытияОС.Событие = ЗНАЧЕНИЕ(Перечисление.бит_му_СобытияОс.НачислениеАмортизации)
	|	И бит_му_СобытияОС.ОсновноеСредство В(&МассивОС)
	|	И бит_му_СобытияОС.Период >= ДОБАВИТЬКДАТЕ(&НачалоПериода, МЕСЯЦ, 1)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабЧасть.НомерСтроки,
	|	ТабЧасть.ОсновноеСредство,
	|	ТабЧасть.ВозмещаемаяСтоимость,
	|	ТабЧасть.Сумма,
	|	ТабЧасть.СчетСниженияСтоимости,
	|	ТабЧасть.СчетДоходовРасходов,
	|	ТабЧасть.Субконто1,
	|	ТабЧасть.Субконто2,
	|	ТабЧасть.Субконто3,
	|	ТабЧасть.Субконто4,
	|	ЕСТЬNULL(ТаблицаПараметров.ЛиквидационнаяСтоимость, 0) КАК ЛиквидационнаяСтоимость,
	|	ТаблицаПараметров.Класс.ВидКласса КАК ВидКласса,
	|	ТаблицаПараметров.Класс,
	|	ЕСТЬNULL(ТаблицаПараметров.ОбъектВФинансовойАренде, ЛОЖЬ) КАК ОбъектВФинансовойАренде,
	|	Принятые.ДатаСостояния КАК ДатаПринятия,
	|	Выбывшие.ДатаСостояния КАК ДатаВыбытия,
	|	ЕСТЬNULL(бит_му_СобытияОССрезПервых.Период, ДАТАВРЕМЯ(3999, 1, 1)) КАК ДатаФормированияРезерва,
	|	ЕСТЬNULL(ПериодыМодернизации.ПериодМодернизации, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаМодернизации,
	|	ЕСТЬNULL(ПериодыМодернизации.ПериодФормированияРезерва, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаФормированияРезерваПослеМодернизации,
	|	ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних.ИнвентарныйНомер,
	|	0 КАК СуммаАмортизации,
	|	0 КАК БалансоваяСтоимостьНач,
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-06-08 (#4146)
	|	ВЫБОР
	|		КОГДА (НЕ ВТ_НеНачислятьАмортизацию.ОсновноеСредство ЕСТЬ NULL )
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НеНачислятьАмортизацию,
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-06-08 (#4146)
	|	ВЫБОР
	|		КОГДА (НЕ НачисленаАмортизацияТекущий.ОсновноеСредство ЕСТЬ NULL )
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НачисленаТекущий,
	|	ВЫБОР
	|		КОГДА (НЕ НачисленаАмортизацияСледующий.ОсновноеСредство ЕСТЬ NULL )
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НачисленаСледующий
	|ИЗ
	|	Документ.бит_му_ОбесценениеОС.ОсновныеСредства КАК ТабЧасть
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПараметров КАК ТаблицаПараметров
	|		ПО ТабЧасть.ОсновноеСредство = ТаблицаПараметров.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_му_СостоянияОС КАК Принятые
	|		ПО ТабЧасть.ОсновноеСредство = Принятые.ОсновноеСредство
	|			И (Принятые.Организация = &Организация)
	|			И (Принятые.Состояние = ЗНАЧЕНИЕ(Перечисление.бит_му_СостоянияОС.ПринятоКУчету))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_му_СостоянияОС КАК Выбывшие
	|		ПО ТабЧасть.ОсновноеСредство = Выбывшие.ОсновноеСредство
	|			И (Выбывшие.Организация = &Организация)
	|			И (Выбывшие.Состояние = ЗНАЧЕНИЕ(Перечисление.бит_му_СостоянияОС.СнятоСУчета))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_му_СобытияОС.СрезПервых(
	|				,
	|				&ЭтоВозвратОбесценения = ИСТИНА
	|					И Организация = &Организация
	|					И ОсновноеСредство В (&МассивОС)
	|					И Событие = ЗНАЧЕНИЕ(Перечисление.бит_му_СобытияОС.ФормированиеРезерва)) КАК бит_му_СобытияОССрезПервых
	|		ПО ТабЧасть.ОсновноеСредство = бит_му_СобытияОССрезПервых.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПериодыМодернизации КАК ПериодыМодернизации
	|		ПО ТабЧасть.ОсновноеСредство = ПериодыМодернизации.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(&МоментВремени, ОсновноеСредство В (&МассивОС)) КАК ПервоначальныеСведенияОСБухгалтерскийУчетСрезПоследних
	|		ПО (ТабЧасть.ОсновноеСредство = бит_му_СобытияОССрезПервых.ОсновноеСредство)
	|		ЛЕВОЕ СОЕДИНЕНИЕ НачисленаАмортизацияСледующий КАК НачисленаАмортизацияСледующий
	|		ПО ТабЧасть.ОсновноеСредство = НачисленаАмортизацияСледующий.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ НачисленаАмортизацияТекущий КАК НачисленаАмортизацияТекущий
	|		ПО ТабЧасть.ОсновноеСредство = НачисленаАмортизацияТекущий.ОсновноеСредство
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-06-08 (#4146)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_НеНачислятьАмортизацию КАК ВТ_НеНачислятьАмортизацию
	|		ПО ТабЧасть.ОсновноеСредство = ВТ_НеНачислятьАмортизацию.ОсновноеСредство
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-06-08 (#4146)
	|ГДЕ
	|	ТабЧасть.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТаблицаПараметров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПериодыМодернизации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2021-06-08 (#4146)
	|УНИЧТОЖИТЬ ВТ_НеНачислятьАмортизацию
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2021-06-08 (#4146)
	|УНИЧТОЖИТЬ НачисленаАмортизацияТекущий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ НачисленаАмортизацияСледующий";
				   
				   
    Результат = Запрос.Выполнить();
	
	ТаблицаОС = Результат.Выгрузить();
	
	СтруктураТаблиц = Новый Структура;
	
	
	Если СтруктураШапкиДокумента.ВидДвижения = Перечисления.бит_му_ВидыДвиженияОбесценения.ВозвратОбесценения Тогда
		
		ДеревоРезультат = бит_му_ВНА.РасчетМоделированиеАмортизации(СтруктураШапкиДокумента,ТаблицаОС);
		
		СтруктураТаблиц.Вставить("РасчетАмортизации",ДеревоРезультат);
		 
	КонецЕсли; 
	
	СтруктураТаблиц.Вставить("ОС",ТаблицаОС);

	
	// Получим параметры классов ВНА
	ПараметрыКлассов = Новый Соответствие;
	МассивКлассов    = ТаблицаОС.ВыгрузитьКолонку("Класс");
	бит_РаботаСКоллекциями.УдалитьПовторяющиесяЭлементыМассива(МассивКлассов);
	
	Для каждого Класс Из МассивКлассов Цикл
		
		СтруктураПараметров = Новый Структура("Организация,Класс",Объект.Организация,Класс);
		ПараметрыКлассов.Вставить(Класс,бит_му_ВНА.ПолучитьПараметрыКлассаВНА(СтруктураПараметров));
	
	КонецЦикла; 
	
	СтруктураТаблиц.Вставить("ПараметрыКлассов",ПараметрыКлассов);
	
	
	Возврат СтруктураТаблиц;
	
КонецФункции

// Функция формирует табличный документ для печати расчета-моделирования амортизации.
// 
// Возвращаемое значение:
//   ТабДокумент   - Табличный документ.
// 
Функция ПечатьРасчетаАмортизации(МассивСсылок)
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	Если МассивСсылок.Количество() = 0 Тогда
		Возврат ТабДокумент;
	КонецЕсли;
	
	ДокСсылка = МассивСсылок[0];
	Макет = ПолучитьМакет("РасчетАмортизации");
	
	// Получим данные для вывода.
	СтруктураШапкиДокумента = бит_ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ДокСсылка);
	СтруктураТаблиц = ПодготовитьТаблицыДокумента(ДокСсылка, СтруктураШапкиДокумента);
	
	Если НЕ СтруктураТаблиц.Свойство("РасчетАмортизации") Тогда
		Возврат ТабДокумент;
	КонецЕсли;
	
	ДеревоРезультат = СтруктураТаблиц.РасчетАмортизации;
	
	ОблМакета = Макет.ПолучитьОбласть("Заголовок");
	
	ТекстЗаголовка = НСтр("ru='Расчет амортизации для контроля обесценения ОС № %1% от %2% г.'");
	ТекстЗаголовка = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстЗаголовка
																			,бит_ОбщегоНазначенияКлиентСервер.ПолучитьНомерНаПечать(ДокСсылка)
																			,Формат(СтруктураШапкиДокумента.Дата,"ДФ='дд ММММ гггг'"));
	ОблМакета.Параметры.ТекстЗаголовка = ТекстЗаголовка;
	
	ТабДокумент.Вывести(ОблМакета);
	
	ОблМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДокумент.Вывести(ОблМакета);
	
	ОблМакета    = Макет.ПолучитьОбласть("Строка");
	ОблМакетаНиз = Макет.ПолучитьОбласть("СтрокаНиз");
	
	ТабДокумент.НачатьАвтогруппировкуСтрок();
	
	Ном = 1;
	Для каждого СтрокаДереваВерх Из ДеревоРезультат.Строки Цикл
		
		ОблМакета.Параметры.ОсновноеСредство    = СтрокаДереваВерх.ОбъектВНА;
		ОблМакета.Параметры.КонтрольнаяСумма    = бит_ОбщегоНазначения.ФорматСумм(СтрокаДереваВерх.БалансоваяСтоимость-СтрокаДереваВерх.СуммаАмортизации);
		ОблМакета.Параметры.БалансоваяСтоимость = бит_ОбщегоНазначения.ФорматСумм(СтрокаДереваВерх.БалансоваяСтоимость);
		ОблМакета.Параметры.СуммаАмортизации    = бит_ОбщегоНазначения.ФорматСумм(СтрокаДереваВерх.СуммаАмортизации);
		ОблМакета.Параметры.НомерСтроки         = Ном;
		ОблМакета.Параметры.ИнвентарныйНомер    = СтрокаДереваВерх.ИнвентарныйНомер;
		ТабДокумент.Вывести(ОблМакета,0);
		
		Для каждого СтрокаДереваНиз Из СтрокаДереваВерх.Строки Цикл
			
			ОблМакетаНиз.Параметры.Период = Формат(СтрокаДереваНиз.Период,"ДФ=dd.MM.yyyy"); 
			ОблМакетаНиз.Параметры.СуммаАмортизации = бит_ОбщегоНазначения.ФорматСумм(СтрокаДереваНиз.СуммаАмортизации);
			ТабДокумент.Вывести(ОблМакетаНиз,1);
			
		КонецЦикла;// По нижним строкам 
		
		Ном = Ном+1;
	КонецЦикла;// По верхним строкам
	
	ТабДокумент.ЗакончитьАвтогруппировкуСтрок();
	
	ОблМакета = Макет.ПолучитьОбласть("Итого");
	ТабДокумент.Вывести(ОблМакета);
	
	ТабДокумент.ПоказатьУровеньГруппировокСтрок(0);
	
	Возврат ТабДокумент;
	
КонецФункции

#КонецОбласти

#КонецЕсли
