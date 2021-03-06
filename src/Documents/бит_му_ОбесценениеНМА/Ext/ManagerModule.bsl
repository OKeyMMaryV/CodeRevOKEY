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
			ПечатьРасчетаАмортизации(МассивОбъектов),,"Документ.бит_му_ОбесценениеНМА.РасчетАмортизации");
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
Функция ПодготовитьТаблицыДокумента(Объект, СтруктураШапкиДокумента) Экспорт
	
	МассивНМА = Объект.НематериальныеАктивы.ВыгрузитьКолонку("НематериальныйАктив");
	бит_РаботаСКоллекциями.УдалитьПовторяющиесяЭлементыМассива(МассивНМА);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка"       ,Объект.Ссылка);
	Запрос.УстановитьПараметр("МассивНМА"    ,МассивНМА);
	Запрос.УстановитьПараметр("Организация"  ,СтруктураШапкиДокумента.Организация);
	Запрос.УстановитьПараметр("МоментВремени",Объект.МоментВремени());
	Запрос.УстановитьПараметр("НачалоПериода",НачалоМесяца(СтруктураШапкиДокумента.Дата));
	Запрос.УстановитьПараметр("КонецПериода" ,КонецМесяца(СтруктураШапкиДокумента.Дата));
	Если СтруктураШапкиДокумента.ВидДвижения = Перечисления.бит_му_ВидыДвиженияОбесценения.ВозвратОбесценения Тогда
		Запрос.УстановитьПараметр("ЭтоВозвратОбесценения",Истина);
	Иначе	
		Запрос.УстановитьПараметр("ЭтоВозвратОбесценения",Ложь);
	КонецЕсли; 
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПараметрыНМА.НематериальныйАктив КАК НематериальныйАктив,
	               |	0 КАК ЛиквидационнаяСтоимость,
	               |	МАКСИМУМ(ВЫБОР
	               |			КОГДА ПараметрыНМА.Параметр = ЗНАЧЕНИЕ(ПланВидовХарактеристик.бит_му_ВидыПараметровВНА.Класс_НМА)
	               |				ТОГДА ПараметрыНМА.ЗначениеПараметра
	               |			ИНАЧЕ NULL
	               |		КОНЕЦ) КАК Класс
				   //++СисИнфо //получаем параметр ОбъектСтроительства //2012-07-23
				   |	,МАКСИМУМ(ВЫБОР
	               |			КОГДА ПараметрыНМА.Параметр = ЗНАЧЕНИЕ(ПланВидовХарактеристик.бит_му_ВидыПараметровВНА.ОбъектСтроительства)
	               |				ТОГДА ПараметрыНМА.ЗначениеПараметра
	               |			ИНАЧЕ NULL
	               |		КОНЕЦ) КАК ОбъектСтроительства
				   //--СисИнфо		
	               |ПОМЕСТИТЬ ТаблицаПараметров
	               |ИЗ
	               |	РегистрСведений.бит_му_ПараметрыНМА.СрезПоследних(
	               |			&МоментВремени,
	               |			НематериальныйАктив В (&МассивНМА)
	               |				И Организация = &Организация
				   //++СисИнфо //получаем параметр ОбъектСтроительства //2012-07-23
				   //|				И Параметр = ЗНАЧЕНИЕ(ПланВидовХарактеристик.бит_му_ВидыПараметровВНА.Класс_НМА)) КАК ПараметрыНМА
	               |				И (Параметр = ЗНАЧЕНИЕ(ПланВидовХарактеристик.бит_му_ВидыПараметровВНА.Класс_НМА) ИЛИ Параметр = ЗНАЧЕНИЕ(ПланВидовХарактеристик.бит_му_ВидыПараметровВНА.ОбъектСтроительства))
				   |			) КАК ПараметрыНМА
				   //--СисИнфо
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ПараметрыНМА.НематериальныйАктив
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЕСТЬNULL(ДатыМодернизации.НематериальныйАктив, ДатыФормированияРезерва.НематериальныйАктив) КАК НематериальныйАктив,
	               |	ЕСТЬNULL(ДатыМодернизации.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК ПериодМодернизации,
	               |	МИНИМУМ(ЕСТЬNULL(ДатыФормированияРезерва.Период, ДАТАВРЕМЯ(1, 1, 1))) КАК ПериодФормированияРезерва
	               |ПОМЕСТИТЬ ПериодыМодернизации
	               |ИЗ
	               |	РегистрСведений.бит_му_СобытияНМА.СрезПоследних(
	               |			&МоментВремени,
	               |			&ЭтоВозвратОбесценения = ИСТИНА
	               |				И Организация = &Организация
	               |				И Событие = ЗНАЧЕНИЕ(Перечисление.бит_му_СобытияНМА.Модернизация)
	               |				И НематериальныйАктив В (&МассивНМА)) КАК ДатыМодернизации
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_му_СобытияНМА КАК ДатыФормированияРезерва
	               |		ПО ДатыМодернизации.Организация = ДатыФормированияРезерва.Организация
	               |			И ДатыМодернизации.НематериальныйАктив = ДатыФормированияРезерва.НематериальныйАктив
	               |			И ДатыМодернизации.Период < ДатыФормированияРезерва.Период
	               |			И (ДатыФормированияРезерва.Событие = ЗНАЧЕНИЕ(Перечисление.бит_му_СобытияНМА.ФормированиеРезерва))
	               |			И (ДатыФормированияРезерва.НематериальныйАктив В (&МассивНМА))
	               |			И (ДатыФормированияРезерва.Организация = &Организация)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ЕСТЬNULL(ДатыМодернизации.НематериальныйАктив, ДатыФормированияРезерва.НематериальныйАктив),
	               |	ЕСТЬNULL(ДатыМодернизации.Период, ДАТАВРЕМЯ(1, 1, 1))
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	бит_му_СобытияНМА.НематериальныйАктив
	               |ПОМЕСТИТЬ НачисленаАмортизацияТекущий
	               |ИЗ
	               |	РегистрСведений.бит_му_СобытияНМА КАК бит_му_СобытияНМА
	               |ГДЕ
	               |	бит_му_СобытияНМА.Организация = &Организация
	               |	И бит_му_СобытияНМА.Событие = ЗНАЧЕНИЕ(Перечисление.бит_му_СобытияНМА.НачислениеАмортизации)
	               |	И бит_му_СобытияНМА.НематериальныйАктив В(&МассивНМА)
	               |	И бит_му_СобытияНМА.Период МЕЖДУ &НачалоПериода И &КонецПериода
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	бит_му_СобытияНМА.НематериальныйАктив
	               |ПОМЕСТИТЬ НачисленаАмортизацияСледующий
	               |ИЗ
	               |	РегистрСведений.бит_му_СобытияНМА КАК бит_му_СобытияНМА
	               |ГДЕ
	               |	бит_му_СобытияНМА.Организация = &Организация
	               |	И бит_му_СобытияНМА.Событие = ЗНАЧЕНИЕ(Перечисление.бит_му_СобытияНМА.НачислениеАмортизации)
	               |	И бит_му_СобытияНМА.НематериальныйАктив В(&МассивНМА)
	               |	И бит_му_СобытияНМА.Период >= ДОБАВИТЬКДАТЕ(&НачалоПериода, МЕСЯЦ, 1) 
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТабЧасть.НомерСтроки,
	               |	ТабЧасть.НематериальныйАктив,
	               |	ТабЧасть.ВозмещаемаяСтоимость,
	               |	ТабЧасть.Сумма,
	               |	ТабЧасть.СчетСниженияСтоимости,
	               |	ТабЧасть.СчетДоходовРасходов,
	               |	ТабЧасть.Субконто1,
	               |	ТабЧасть.Субконто2,
	               |	ТабЧасть.Субконто3,
	               |	ТабЧасть.Субконто4,
	               |	ЕСТЬNULL(ТаблицаПараметров.ЛиквидационнаяСтоимость, 0) КАК ЛиквидационнаяСтоимость,
	               |	ТаблицаПараметров.Класс,
				   //++СисИнфо //получаем параметр ОбъектСтроительства //2012-07-23
				   |	ТаблицаПараметров.ОбъектСтроительства,
				   //--СисИнфо
	               |	Принятые.ДатаСостояния КАК ДатаПринятия,
	               |	Выбывшие.ДатаСостояния КАК ДатаВыбытия,
	               |	ВЫБОР
	               |		КОГДА (НЕ НачисленаАмортизацияТекущий.НематериальныйАктив ЕСТЬ NULL )
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК НачисленаТекущий,
	               |	ВЫБОР
	               |		КОГДА (НЕ НачисленаАмортизацияСледующий.НематериальныйАктив ЕСТЬ NULL )
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК НачисленаСледующий,
	               |	ЕСТЬNULL(бит_му_СобытияНМАСрезПервых.Период, ДАТАВРЕМЯ(3999, 1, 1)) КАК ДатаФормированияРезерва,
	               |	ЕСТЬNULL(ПериодыМодернизации.ПериодМодернизации, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаМодернизации,
	               |	ЕСТЬNULL(ПериодыМодернизации.ПериодФормированияРезерва, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаФормированияРезерваПослеМодернизации,
	               |	0 КАК СуммаАмортизации,
	               |	0 КАК БалансоваяСтоимостьНач
	               |ИЗ
	               |	Документ.бит_му_ОбесценениеНМА.НематериальныеАктивы КАК ТабЧасть
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПараметров КАК ТаблицаПараметров
	               |		ПО ТабЧасть.НематериальныйАктив = ТаблицаПараметров.НематериальныйАктив
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_му_СостоянияНМА КАК Принятые
	               |		ПО ТабЧасть.НематериальныйАктив = Принятые.НематериальныйАктив
	               |			И (Принятые.Организация = &Организация)
	               |			И (Принятые.Состояние = ЗНАЧЕНИЕ(Перечисление.бит_му_СостоянияНМА.ПринятоКУчету))
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_му_СостоянияНМА КАК Выбывшие
	               |		ПО ТабЧасть.НематериальныйАктив = Выбывшие.НематериальныйАктив
	               |			И (Выбывшие.Организация = &Организация)
	               |			И (Выбывшие.Состояние = ЗНАЧЕНИЕ(Перечисление.бит_му_СостоянияНМА.СнятоСУчета))
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_му_СобытияНМА.СрезПервых(
	               |				,
	               |				&ЭтоВозвратОбесценения = ИСТИНА
	               |					И Организация = &Организация
	               |					И НематериальныйАктив В (&МассивНМА)
	               |					И Событие = ЗНАЧЕНИЕ(Перечисление.бит_му_СобытияНМА.ФормированиеРезерва)) КАК бит_му_СобытияНМАСрезПервых
	               |		ПО ТабЧасть.НематериальныйАктив = бит_му_СобытияНМАСрезПервых.НематериальныйАктив
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ПериодыМодернизации КАК ПериодыМодернизации
	               |		ПО ТабЧасть.НематериальныйАктив = ПериодыМодернизации.НематериальныйАктив
	               |		ЛЕВОЕ СОЕДИНЕНИЕ НачисленаАмортизацияТекущий КАК НачисленаАмортизацияТекущий
	               |		ПО ТабЧасть.НематериальныйАктив = НачисленаАмортизацияТекущий.НематериальныйАктив
	               |		ЛЕВОЕ СОЕДИНЕНИЕ НачисленаАмортизацияСледующий КАК НачисленаАмортизацияСледующий
	               |		ПО ТабЧасть.НематериальныйАктив = НачисленаАмортизацияСледующий.НематериальныйАктив
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
	               |УНИЧТОЖИТЬ НачисленаАмортизацияТекущий
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |УНИЧТОЖИТЬ НачисленаАмортизацияСледующий";
				   
				   
    Результат = Запрос.Выполнить();
	
	ТаблицаНМА = Результат.Выгрузить();
	
	СтруктураТаблиц = Новый Структура;
	
	
	Если СтруктураШапкиДокумента.ВидДвижения = Перечисления.бит_му_ВидыДвиженияОбесценения.ВозвратОбесценения Тогда
		
		ДеревоРезультат = бит_му_ВНА.РасчетМоделированиеАмортизации(СтруктураШапкиДокумента,ТаблицаНМА);
		
		СтруктураТаблиц.Вставить("РасчетАмортизации",ДеревоРезультат);
		 
	КонецЕсли; 
	
	СтруктураТаблиц.Вставить("НМА",ТаблицаНМА);

	
	// Получим параметры классов ВНА
	ПараметрыКлассов = Новый Соответствие;
	МассивКлассов    = ТаблицаНМА.ВыгрузитьКолонку("Класс");
	бит_РаботаСКоллекциями.УдалитьПовторяющиесяЭлементыМассива(МассивКлассов);
	
	Для каждого Класс Из МассивКлассов Цикл
		
		СтруктураПараметров = Новый Структура("Организация,Класс",СтруктураШапкиДокумента.Организация,Класс);
		ПараметрыКлассов.Вставить(Класс,бит_му_ВНА.ПолучитьПараметрыКлассаВНА(СтруктураПараметров));
	
	КонецЦикла; 
	
	СтруктураТаблиц.Вставить("ПараметрыКлассов",ПараметрыКлассов);
	
	
	Возврат СтруктураТаблиц;
	
КонецФункции // ПодготовитьТаблицуБДДС()

// Функция формирует табличный документ для печати расчета-моделирования амортизации.
// 
// Возвращаемое значение:
//   ТабДокумент   - Табличный документ.
// 
Функция ПечатьРасчетаАмортизации(МассивСсылок)
	
	Если МассивСсылок.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДокСсылка = МассивСсылок[0];
	
	ТабДокумент = Новый ТабличныйДокумент;
	Макет = ПолучитьМакет("РасчетАмортизации");
	
	// Получим данные для вывода
	СтруктураШапкиДокумента = бит_ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ДокСсылка);
	СтруктураТаблиц = ПодготовитьТаблицыДокумента(ДокСсылка, СтруктураШапкиДокумента);
	
	Если НЕ СтруктураТаблиц.Свойство("РасчетАмортизации") Тогда
		Возврат ТабДокумент;
	КонецЕсли;
	
	ДеревоРезультат = СтруктураТаблиц.РасчетАмортизации;
	
	ОблМакета = Макет.ПолучитьОбласть("Заголовок");
	ОблМакета.Параметры.ТекстЗаголовка = "Расчет амортизации для контроля обесценения НМА № "
										+бит_ОбщегоНазначенияКлиентСервер.ПолучитьНомерНаПечать(ДокСсылка)
										+" от "
										+Формат(СтруктураШапкиДокумента.Дата,"ДФ='дд ММММ гггг'")
										+ " г.";
	
	ТабДокумент.Вывести(ОблМакета);
	
	ОблМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДокумент.Вывести(ОблМакета);
	
	ОблМакета    = Макет.ПолучитьОбласть("Строка");
	ОблМакетаНиз = Макет.ПолучитьОбласть("СтрокаНиз");
	
	ТабДокумент.НачатьАвтогруппировкуСтрок();
	
	Ном = 1;
	Для Каждого СтрокаДереваВерх Из ДеревоРезультат.Строки Цикл
		
		ОблМакета.Параметры.ОсновноеСредство    = СтрокаДереваВерх.ОбъектВНА;
		ОблМакета.Параметры.КонтрольнаяСумма    = бит_ОбщегоНазначения.ФорматСумм(СтрокаДереваВерх.БалансоваяСтоимость-СтрокаДереваВерх.СуммаАмортизации);
		ОблМакета.Параметры.БалансоваяСтоимость = бит_ОбщегоНазначения.ФорматСумм(СтрокаДереваВерх.БалансоваяСтоимость);
		ОблМакета.Параметры.СуммаАмортизации    = бит_ОбщегоНазначения.ФорматСумм(СтрокаДереваВерх.СуммаАмортизации);
		ОблМакета.Параметры.НомерСтроки         = Ном;
		ОблМакета.Параметры.ИнвентарныйНомер    = СтрокаДереваВерх.ИнвентарныйНомер;
		ТабДокумент.Вывести(ОблМакета,0);
		
		Для Каждого СтрокаДереваНиз Из СтрокаДереваВерх.Строки Цикл
			
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
	
КонецФункции // ПечатьРасчетаАмортизации()

#КонецОбласти

#КонецЕсли
