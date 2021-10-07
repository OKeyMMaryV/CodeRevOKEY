﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ИмяМетаданных = "БП.РазделУчета.БанкИКасса";
	ЗаголовокФормы = Нстр("ru = 'Новости: Банк и касса'");
	
	// По всем лентам новостей
	СписокЛентНовостей = Неопределено;
	// Отбор по новый / опытный пользователь
	//СписокЛентНовостей = ОбработкаНовостейПереопределяемыйПовтИсп.ПолучитьСписокЛентНовостейДляКонтекстныхНовостей();

	ОбработкаНовостейКлиент.ПоказатьКонтекстныеНовости(
		Неопределено, // ФормаВладелец
		СписокЛентНовостей, // СписокЛентНовостей
		ИмяМетаданных, // ИмяМетаданных
		"", // ИмяФормы,
		"", // ИмяСобытия
		Новый Структура("ЗаголовокФормы, СкрыватьКолонкуЛентаНовостей, СкрыватьКолонкуПодзаголовок, СкрыватьКолонкуДатаПубликации, ПоказыватьПанельНавигации, РежимОткрытияОкна",
			ЗаголовокФормы, // ЗаголовокФормы
			Ложь, // СкрыватьКолонкуЛентаНовостей
			Истина, // СкрыватьКолонкуПодзаголовок
			Ложь, // СкрыватьКолонкуДатаПубликации
			Ложь, // ПоказыватьПанельНавигации
			"Независимый" // РежимОткрытияОкна ("Независимый", "Блокировать окно владельца" (по-умолчанию), "Блокировать весь интерфейс")
		)
	);

КонецПроцедуры
